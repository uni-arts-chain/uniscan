desc "Update creator of Ethereum NFT contracts one by one"
task update_creator: :environment do
  while true

    collection = Collection.where(
      # "creator_id is null and " +
      "creator_address is null"
    ).first

    if collection.nil?
      sleep 10
      next
    end

    puts collection.id
    begin
      tx = Etherscan.get_contract_creation_transacton(collection.contract_address)

      if tx["to"] == "" && tx["contractAddress"] == collection.contract_address
        account = Account.find_by_address tx["from"]

        if account.nil?
          account = Account.create(
            address: tx["from"],
            blockchain: collection.blockchain
          )
        end

        collection.update(
          creator: account,
          creator_address: tx["from"],
          created_at_block: tx["blockNumber"].to_i,
          created_at_timestamp: tx["timeStamp"].to_i,
          created_at_tx: tx["hash"]
        )
      else
        # Not found
        collection.update creator_address: "NOT FOUND"
      end
    rescue => ex
      puts ex.message
      sleep 10
    end

    # etherscan speed limit
    # https://docs.etherscan.io/support/rate-limits
    sleep 5
  end
end
