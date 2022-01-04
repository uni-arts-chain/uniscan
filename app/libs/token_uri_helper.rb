# Token uri help methods
class TokenUriHelper

  # Get the token_uri's content as a json object.
  #
  # @return [Object] the token_uri's content.
  def self.get_content(token_uri)
    if token_uri.start_with?("data:")
      # json base64 encoded
      if token_uri.start_with?("data:application/json;base64,")
        return JSON.parse(Base64.decode64(token_uri[29..]))
      else
        raise "Not support data: #{token_uri}"
      end
    else
      # convert to gateway url if it is an ipfs scheme
      # TODO: try another gateway endpoint if failed.
      if token_uri.start_with?("ipfs://")
        token_uri = "https://dweb.link/ipfs/#{token_uri[7..]}"
      end

      faraday = Faraday.new do |f|
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end
      response = faraday.get token_uri
      
      if response.status == 200
        # body = response.body.gsub("\xEF\xBB\xBF".force_encoding("ASCII-8BIT"), '')
        body = response.body
        fixed_body = StringHelper.fix_encoding(body)
        if fixed_body.strip.start_with?("{") 
          return JSON.parse(fixed_body)
        else
          raise "token_uri's response body is not json"
        end
      else
        raise "token_uri's response status is #{response.status}"
      end

    end

  end
end
