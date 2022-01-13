# The sidekiq worker for processing incoming erc721 events.
#
# This is the entrance of ERC721 NFTs into uniscan.
class ProcessErc721EventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'erc721_events', retry: false

  def perform(args)
    args.symbolize_keys!

    blockchain = args[:blockchain]
    block_number = args[:block_number]
    contract_address = args[:address]
    transaction_hash = args[:transaction_hash]
    from = args[:from]
    to = args[:to]
    timestamp = args[:timestamp]
    token_id = args[:token_id]
    token_uri = args[:token_uri]&.strip
    name = args[:name]
    symbol = args[:symbol]
    # total_supply = args[:total_supply]

    # TODO: Check args
    # return unless token_uri =~ URI::regexp

  end
end
