# A +Collection+ represents a NFT contract on the blockchain.
#
# +contract_platform+ can only be +evm+ now.  
# +nft_type+ can be +erc721+ or +erc1155+.  
# +total_supply+ is from contract. But it is not used now. See +supply+.  
# +supply+ is calulated from the transfers. See {TokenOwnership#update_collection_supply}.  
# +holders_count+. See {TokenOwnership#update_collection_holders}.  
# +creator+, +creator_address+, +created_at_block+, +created_at_timestamp+,
# and +created_at_tx+ are now only for Ethereum and are from Etherscan. See {Etherscan}
#
# == Schema Information
#
# Table name: collections
#
#  id                   :bigint           not null, primary key
#  name                 :text(65535)
#  symbol               :text(65535)
#  blockchain_id        :integer
#  contract_platform    :integer          default("evm")
#  contract_address     :string(255)
#  nft_type             :integer          default("erc721")
#  total_supply         :decimal(65, )
#  holders_count        :integer          default(0)
#  transfers_count      :integer          default(0)
#  creator_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  supply               :decimal(65, )    default(0)
#  creator_address      :string(255)
#  created_at_block     :integer
#  created_at_timestamp :integer
#  created_at_tx        :string(255)
#  metadata             :boolean
#
class Collection < ApplicationRecord
  belongs_to :blockchain
  belongs_to :creator, class_name: "Account", optional: true
  has_many :tokens, -> { 
    includes(collection: [:blockchain])
      .includes(:accounts)
      .eligible
      .with_attached_image
  }

  validates :blockchain_id, presence: true
  validates :contract_address, presence: true

  enum contract_platform: [ :evm, :wasm ]
  enum nft_type: [ :erc721, :erc1155 ]

  # Get the explorer url the contract address.
  #
  # @return [String]
  def explorer_url
    self.blockchain.explorer_address_url.gsub("{address}", self.contract_address)
  end

  # A representative token used for the collection's cover.
  # The first token of its token list.
  #
  # TODO: add fields to the cover.
  # @return [Token]
  def representative_token
    self.tokens.first
  end
end
