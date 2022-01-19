namespace :token_uri do
  desc "Parse the token_uri one by one"
  task parse: :environment do
    while true
      token = Token.where("token_uri_processed = false").order(id: :desc).first
      
      if token.nil?
        sleep 3 
        next
      end

      puts token.id
      token.process_token_uri
    end
  end

end
