# == Schema Information
#
# Table name: collections
#
#  id                :bigint           not null, primary key
#  name              :string(255)
#  symbol            :string(255)
#  blockchain_id     :integer
#  contract_platform :integer          default("evm")
#  contract_address  :string(255)
#  nft_type          :integer          default("erc721")
#  total_supply      :integer
#  holders_count     :integer          default(0)
#  transfers_count   :integer          default(0)
#  creator_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Collection < ApplicationRecord
  belongs_to :blockchain
  # belongs_to :creator, class_name: "Account"
  has_many :tokens

  validates :blockchain_id, presence: true
  validates :contract_address, presence: true

  enum contract_platform: [ :evm, :wasm ]
  enum nft_type: [ :erc721, :erc1155 ]

  def explorer_url
    self.blockchain.explorer_base_url + self.contract_address
  end
end
