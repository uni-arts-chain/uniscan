# == Schema Information
#
# Table name: tokens
#
#  id                 :bigint           not null, primary key
#  token_id_on_chain  :string(255)
#  collection_id      :integer
#  unique             :boolean          default(TRUE)
#  supply             :integer          default(1)
#  owner_id           :integer
#  name               :string(255)
#  description        :text(65535)
#  image              :string(255)
#  token_uri          :text(65535)
#  token_uri_err      :text(65535)
#  is_permanent       :boolean
#  transfers_count    :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  holders_count      :integer          default(0)
#  invalidated        :boolean          default(FALSE)
#  invalidated_reason :integer
#
class Token < ApplicationRecord

  belongs_to :collection
  belongs_to :owner, class_name: "Account"

  validates :token_id_on_chain, presence: true
  enum invalidated_reason: [ :token_uri_err, :blacklisted ]

  after_create_commit { 
    broadcast_prepend_to('tokens') 

    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:_")
    broadcast_prepend_to("tokens:_:#{self.collection.nft_type_before_type_cast}")
    broadcast_prepend_to("tokens:#{self.collection.blockchain_id}:#{self.collection.nft_type_before_type_cast}")
  }

  delegate :blockchain, to: :collection
  delegate :nft_type, to: :collection

  private

  def q_string_of
    self.collection.blockchain_id
  end
end
