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
    { 
      name: 'Ethereum', 
      testnet: false, 
      explorer_token_url: "https://etherscan.io/token/{address}", 
      explorer_address_url: "https://etherscan.io/address/{address}"
    },
    { 
      name: 'Darwinia', 
      testnet: false,
      explorer_token_url: "https://darwinia.subscan.io/account/{address}",
      explorer_address_url: "https://darwinia.subscan.io/account/{address}"
    },
    { 
      name: 'Moonriver', 
      testnet: false,
      explorer_token_url: "https://moonbeam-explorer.netlify.app/address/{address}?network=Moonriver",
      explorer_address_url: "https://moonbeam-explorer.netlify.app/address/{address}?network=Moonriver"
    },
    { 
      name: 'Pangolin', 
      testnet: true,
      explorer_token_url: "https://pangolin.subscan.io/account/{address}",
      explorer_address_url: "https://pangolin.subscan.io/account/{address}"
    }
  ]
)
