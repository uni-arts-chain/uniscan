# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

Blockchain.create(
  [
    { name: 'Ethereum', testnet: false, explorer_base_url: "https://etherscan.io/token/" },
    { name: 'Darwinia', testnet: false },
    { name: 'Moonbeam', testnet: false },
    { name: 'Pangolin', testnet: true }
  ]
)

if Rails.env == "development"
  owner = Account.first 
  10000.times do |i|
    collection = Collection.find (rand(20) + i) % 19 + 1
    Token.create(
      collection: collection,
      token_id_on_chain: rand(1000000000).to_s,
      token_uri: "https://faker",
      owner: owner,
      name: Faker::Name.name,
      image: "https://loremflickr.com/300/300?random=#{rand(1000000000)}"
    )
    sleep 1
  end
end
