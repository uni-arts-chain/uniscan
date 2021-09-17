# == Schema Information
#
# Table name: tokens
#
#  id                :bigint           not null, primary key
#  token_id_on_chain :string(255)
#  collection_id     :integer
#  unique            :boolean          default(TRUE)
#  supply            :integer          default(1)
#  owner_id          :integer
#  name              :string(255)
#  description       :text(65535)
#  image             :string(255)
#  token_uri         :text(65535)
#  token_uri_err     :text(65535)
#  ipfs              :boolean          default(FALSE)
#  transfers_count   :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  holders_count     :integer          default(0)
#  token_uri_parsed  :boolean          default(FALSE)
#
class Token < ApplicationRecord

  belongs_to :collection
  has_many :properties
  has_many :token_ownerships, -> { where('balance > 0') }
  has_many :accounts, through: :token_ownerships

  validates :token_id_on_chain, presence: true

  delegate :blockchain, to: :collection
  delegate :nft_type, to: :collection

  scope :eligible, -> {
    where(
      "token_uri_err is null and " + 
      "TRIM(token_uri) != '' and " +
      "image is not null and " + 
      "TRIM(image) != ''"
    )
  }

  def historical_owners_count
    Transfer.where(token: self).distinct.count(:token_id)
  end

  def owner
    self.accounts[0]
  end

  def owners
    self.accounts
  end

  def broadcast
    broadcast_prepend_to('tokens') 

    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:_")
    broadcast_prepend_to("tokens:_:#{self.collection.nft_type_before_type_cast}")
    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:#{self.collection.nft_type_before_type_cast}")
  end

  private

  def q_string_of
    self.collection.blockchain_id
  end
end
