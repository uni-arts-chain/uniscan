namespace :token_uri do
  desc "Parse the token_uri one by one"
  task parse: :environment do
    while true

      token = Token.where(
        "token_uri_parsed = false"
      ).first
      
      if token.nil?
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

        parse_token_uri(token_uri, token)
      rescue => ex
        set_err(token, ex.message)
      end

    end
  end

end

# TODO: more precise
# https://github.com/ipfs/specs/issues/248
# https://github.com/ipfs/in-web-browsers/blob/master/ADDRESSING.md
def is_ipfs_uri?(uri)
  uri.include?("/ipfs/") || uri.start_with?("ipfs://")
end

# infos:
# https://eips.ethereum.org/EIPS/eip-721
# https://eips.ethereum.org/EIPS/eip-1155#metadata
# https://docs.opensea.io/docs/metadata-standards
def parse_token_uri(token_uri, token)
  # convert to gateway url if it is an ipfs scheme
  if token_uri.start_with?("ipfs://")
    token_uri = "https://dweb.link/ipfs/#{token_uri[7..]}"
  end

  faraday = Faraday.new do |f|
    f.response :follow_redirects
    f.response :json
    f.adapter Faraday.default_adapter
  end
  response = faraday.get token_uri
  
  if response.status == 200
    body = response.body
    clean(token)
    parse_content(token, body)
  else
    err_msg = "Response status is #{response.status}"
    set_err(token, err_msg)
  end
end

def clean(token)
  token.update(
    token_uri_err: nil,
  )

  Property.where(token: token).delete_all
end

def parse_content(token, body)
  if body["image"].nil?
    err_msg = "The `image` is a required property."
    set_err(token, err_msg)
  else
    is_ipfs = is_ipfs_uri?(token.token_uri) && is_ipfs_uri?(body["image"])
    token.update(
      name: body["name"],
      description: body["description"],
      image: body["image"],
      token_uri_parsed: true,
      ipfs: is_ipfs
    ) 

    body.each_pair do |name, value|
      unless %w[name description image].include?(name)
        v = if value.class == Hash || value.class == Array
              value.to_json
            else
              value.to_s
            end
        Property.create(
          name: name,
          value: v,
          token: token
        )
      end
    end

  end
end

def set_err(token, err_msg)
  puts err_msg
  token.update(
    token_uri_err: err_msg,
    token_uri_parsed: true
  )
end
