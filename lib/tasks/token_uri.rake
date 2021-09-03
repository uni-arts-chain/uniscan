namespace :token_uri do
  desc "Parse the token_uri one by one"
  task parse: :environment do
    while true

      token = Token.where(
        "name is null and " +
        "description is null and " +
        "image is null and " +
        "(token_uri is not null and TRIM(token_uri) != '') and " +
        "token_uri_err is null"
      ).first
      
      if token.blank?
        sleep 3 
        next
      end

      puts token.id
      begin
        token_uri = 
          if token.collection.erc1155? && token.token_uri.include?("{id}")
            hex_token_id_on_chain = token.token_id_on_chain.to_i.to_s(16).rjust(64, "0")
            token.token_uri.gsub("{id}", hex_token_id_on_chain)
          else
            token.token_uri
          end

        set_is_permanent(token)
        parse_token_uri(token_uri, token)
      rescue => ex
        set_err(token, ex.message)
      end

    end
  end

end

def set_is_permanent(token)
  token.update is_permanent: is_permanent_uri?(token.token_uri)
end

# TODO: more precise
def is_permanent_uri?(token_uri)
  token_uri.include?("/ipfs/Qm")
end

def parse_token_uri(token_uri, token)
  faraday = Faraday.new do |f|
    f.response :follow_redirects
    f.response :json
    f.adapter Faraday.default_adapter
  end
  response = faraday.get token_uri
  
  if response.status == 200
    body = response.body
    if body["name"] or body["description"] or body["image"]
      token.update(
        name: body["name"],
        description: body["description"],
        image: body["image"]
      ) 
    else # if all nil
      err_msg = "The name, description and image are all null"
      set_err(token, err_msg)
    end
  else
    err_msg = "Response status is #{response.status}"
    set_err(token, err_msg)
  end
end

def set_err(token, err_msg)
  puts err_msg
  token.update(
    token_uri_err: err_msg,
    invalidated: true,
    invalidated_reason: Token.invalidated_reasons[:token_uri_err]
  )
end
