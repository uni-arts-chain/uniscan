require_relative './thegraph2.rb'
namespace :fetch_transfers do
  desc "Fetch transfers from thegraph"
  task fetch: :environment do
    while true

      begin
        last_transfer = Transfer.order(id: :desc).limit(1).first

        result = 
          if last_transfer.nil?
            TGAPI2::Client.query(InitTransfersQuery, 
                                variables: {
                                  first: TRANSFERS_QUERY_BATCH_SIZE
                                }
                              )
          else
            TGAPI2::Client.query(TransfersQuery, 
                                variables: {
                                  first: TRANSFERS_QUERY_BATCH_SIZE,
                                  last_timestamp: last_transfer.timestamp
                                }
                              )
          end

        if result.data.transfers.length > 0
          result.data.transfers.each do |t|
            contract_address = t.token.registry.id
            token_id = t.token.identifier
            token_uri = t.token.uri
            name = t.token.registry.name
            symbol = t.token.registry.symbol
            metadata = t.token.registry.supports_metadata
            txhash = t.transaction.id
            block_number = t.transaction.block_number
            timestamp = t.timestamp
            from = t.from.id
            to = t.to.id
            # a2 = Time.now
            Transfer.create_transfer("Ethereum", block_number, contract_address, txhash, from, to, timestamp, token_id, token_uri, name, symbol)
            # puts Time.now - a2
          end
        else
          puts "There is no more transfers, wait 1 minute."
          sleep 60
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


