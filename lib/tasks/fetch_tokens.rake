require_relative './thegraph.rb'
namespace :fetch_tokens do
  desc "Fetch tokens from thegraph"
  task fetch: :environment do
    while true

      # loop --------------
      begin
        # 假设这条记录是一定存在的
        ctrl = TokensInfo.find_by_key("ctrl").value
        break if ctrl == "1"

        last_mint_time = TokensInfo.find_by_key("last_token_mint_time").value&.to_i
        puts last_mint_time
        
        result = 
          if last_mint_time.nil?
            puts "Init query tokens ..."
            TGAPI::Client.query(InitTokensQuery, 
                                variables: {
                                  first: TOKENS_QUERY_BATCH_SIZE
                                }
                              )
          else
            puts "Query tokens ..."
            TGAPI::Client.query(TokensQuery, 
                                variables: {
                                  first: TOKENS_QUERY_BATCH_SIZE, 
                                  last_mint_time: last_mint_time
                                }
                              )
          end

        if result.data.tokens.length > 0
          result.data.tokens.each do |t|
            token_contract_address_and_token_id = t.id.split("_")
            token_contract_address = token_contract_address_and_token_id[0]
            token_id = token_contract_address_and_token_id[1]
            token_uri = t.token_uri
            mint_time = t.mint_time

            if Token.find_by(contract_address: token_contract_address, token_id_on_chain: token_id).nil?
              create_token(token_contract_address, token_id, token_uri, mint_time)
            end
          end

          last_token = result.data.tokens.last
          TokensInfo.find_by_key("last_token_mint_time").update({value: last_token.mint_time})
        else
          puts "There is no more tokens, wait 1 minute."
          sleep 60
        end
      rescue => ex
        puts "-----"
        puts "Error, sleep 60 seconds."
        puts ex.message
        sleep 60
      end
      # loop --------------
    end

  end
end

def create_token(token_contract_address, token_id, token_uri, mint_time)
  info = TokensInfo.find_by_key("tokens_count")
  collection = Collection.find_by_contract_address(token_contract_address)
  if collection.nil?
    raise "collection #{contract_address} not exist"
  end
  ori_count = info.value.to_i
  ActiveRecord::Base.transaction do
    Token.create!({
      collection: collection,
      contract_address: token_contract_address,
      token_id_on_chain: token_id,
      token_uri: token_uri.blank? ? nil : token_uri,
      mint_time: mint_time
    })

    info.update!({value: ori_count + 1})

    ori_total_supply = collection.total_supply
    collection.update!(total_supply: ori_total_supply + 1)
  end
end
