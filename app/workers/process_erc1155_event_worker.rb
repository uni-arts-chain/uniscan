# The sidekiq worker for processing incoming erc1155 events.
#
# This is the entrance of ERC1155 NFTs into uniscan.
class ProcessErc1155EventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'erc1155_events', retry: false

  def perform(args)
    args.symbolize_keys!

    blockchain = args[:blockchain]
    block_number = args[:block_number]
    address = args[:address]
    transaction_hash = args[:transaction_hash]
    from = args[:from]
    to = args[:to]
    token_id = args[:token_id]
    amount = args[:amount]
    token_uri = args[:token_uri]&.strip

    # TODO: Check args
    return unless token_uri =~ URI::regexp

    blockchain = Blockchain.find_by_name(blockchain)
    return if blockchain.blank?

    collection = Collection.find_by_contract_address(address)
    if collection.blank?
      collection = Collection.create(
        blockchain: blockchain,
        contract_address: address,
        nft_type: Collection.nft_types[:erc1155]
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

    if token_uri.length > 65535
      raise "The token_uri of #{address}/#{token_id} is too long" 
    else
      token = Token.find_by(collection: collection, token_id_on_chain: token_id)
      if token.blank?
        token = Token.create(
          collection: collection,
          token_id_on_chain: token_id,
          token_uri: token_uri,
          unique: false
        )
      else
        token.update(
          token_uri: token_uri
        )
      end
      transfer = Transfer.find_by(
        collection: collection,
        token: token,
        from: from_account,
        to: to_account,
        txhash: transaction_hash
      )
      if transfer.blank?
        transfer = Transfer.create(
          collection: collection,
          token: token,
          from: from_account,
          to: to_account,
          block_number: block_number,
          txhash: transaction_hash,
          amount: amount
        )
      end
    end

  end
end
