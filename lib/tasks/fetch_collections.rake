require_relative './thegraph.rb'
namespace :fetch_collections do
  desc "Fetch token contracts from thegraph"
  task fetch: :environment do
    while true
      begin
        # 假设这条记录是一定存在的
        ctrl = CollectionsInfo.find_by_key("ctrl").value
        break if ctrl == "1"

        last_address = CollectionsInfo.find_by_key("last_token_contract_address").value
        
        result = 
          if last_address.nil?
            puts "Init query ..."
            TGAPI::Client.query(InitTokenContractsQuery, 
                                variables: {
                                  first: TOKEN_CONTRACTS_QUERY_BATCH_SIZE
                                }
                              )
          else
            puts "Query ..."
            TGAPI::Client.query(TokenContractsQuery, 
                                variables: {
                                  first: TOKEN_CONTRACTS_QUERY_BATCH_SIZE, 
                                  last_id: last_address
                                }
                              )
          end

        if result.data.token_contracts.length > 0
          result.data.token_contracts.each do |tc|
            if Collection.find_by_contract_address(tc.id).nil?
              create_collection(tc.id, tc.name, tc.symbol, tc.supports_eip721_metadata)
            end
          end
          last_tc = result.data.token_contracts.last
          CollectionsInfo.find_by_key("last_token_contract_address").update({value: last_tc.id})
        else
          CollectionsInfo.find_by_key("last_token_contract_address").update({value: nil})
          puts "++++++++++++++++++++++++++++++++++"
          puts "Finished, sleep 5 minutes and rerun."
          sleep 5*60
        end
      rescue => ex
        puts "-----"
        puts "Error, sleep 60 seconds."
        puts ex.message
        sleep 60
      end
    end

  end
end

def create_collection(address, name, symbol, supports_eip721_metadata)
  info = CollectionsInfo.find_by_key("token_contracts_count")
  ori_count = info.value.to_i
  ActiveRecord::Base.transaction do
    Collection.create({
      contract_address: address,
      name: name,
      symbol: symbol,
      metadata: supports_eip721_metadata,
      blockchain_id: 1

    })

    info.update({value: ori_count + 1})
  end
end
