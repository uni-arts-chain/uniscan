# desc "Generate fake transfer data"
# task update_creator: :environment do
#   if Rails.env != "production"

#     # erc721

#     blockchain = %[Ethereum Darwinia Moonriver Pangolin][rand(4)]
#     block_number = args[:block_number]
#     address = args[:address]
#     transaction_hash = args[:transaction_hash]
#     from = args[:from]
#     to = args[:to]
#     token_id = args[:token_id]
#     token_uri = args[:token_uri]
#     name = args[:name]
#     symbol = args[:symbol]
#     total_supply = args[:total_supply]
#   end
# end

# class Erc721Generator
#   def initialize
#     @blockchain = "Ethereum"
#     @total_supply = 9862
#     @block_number = 13228300
#     @name = 
#     @token_id = 0
#   end
  
#   def get_erc721
#     address = Faker::Blockchain::Ethereum.address
#     transaction_hash = "0xa6f945a3dc3e0e7d07409f86e6e48ed82536ca5262d24e3cfc7f52c0f1436b55"
#     from = Faker::Blockchain::Ethereum.address
#     to = Faker::Blockchain::Ethereum.address
#     token_id = @token_id.to_s
#     token_uri = "ipfs://QmfB3KH8GuZA9xoTCNwwiMEMk9hZBUaUZnMMWKra57oUse/#{token_id}.json"
#     name = Faker::Name.name
#     symbol = args[:symbol]
#     total_supply = args[:total_supply]

#     @token_id += 1
#   end
# end
