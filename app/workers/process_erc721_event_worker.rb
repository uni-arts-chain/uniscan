class ProcessErc721EventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'erc721_events'

  def perform(args)
    args.symbolize_keys!

    blockchain = args[:blockchain]
    block_number = args[:block_number]
    address = args[:address]
    transaction_hash = args[:transaction_hash]
    from = args[:from]
    to = args[:to]
    token_id = args[:token_id]
    token_uri = args[:token_uri]&.strip
    name = args[:name]
    symbol = args[:symbol]
    # total_supply = args[:total_supply]

    # TODO: Check args

    blockchain = Blockchain.find_by_name(blockchain)
    return if blockchain.blank?

    collection = Collection.find_by_contract_address(address)
    if collection.blank?
      collection = Collection.create(
        blockchain: blockchain,
        contract_address: address,
        name: name,
        symbol: symbol
        # total_supply: total_supply
      )
    else
      collection.update(
        name: name,
        symbol: symbol
        # total_supply: total_supply
      )
    end
    
    from_account = Account.find_by(address: from, blockchain_id: blockchain.id)
    if from_account.blank?
      from_account = Account.create(
        address: from,
        blockchain_id: blockchain.id
      )
    end

    to_account = Account.find_by(address: to, blockchain_id: blockchain.id)
    if to_account.blank?
      to_account = Account.create(
        address: to,
        blockchain_id: blockchain.id
      )
    end

    token = Token.find_by(collection: collection, token_id_on_chain: token_id)
    if token.blank?
      token = Token.create(
        collection: collection,
        token_id_on_chain: token_id,
        token_uri: token_uri
      )
    end

    transfer = Transfer.find_by(txhash: transaction_hash)
    if transfer.blank?
      transfer = Transfer.create(
        collection: collection,
        token: token,
        from: from_account,
        to: to_account,
        block_number: block_number,
        txhash: transaction_hash,
        amount: 1
      )
    end
  end
end
