# == Schema Information
#
# Table name: accounts
#
#  id            :bigint           not null, primary key
#  address       :string(255)
#  blockchain_id :integer
#  level         :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Account < ApplicationRecord
  belongs_to :blockchain
  has_many :token_ownerships, -> { where('balance > 0') }
  has_many :tokens, through: :token_ownerships

  validates :address, presence: true

  def tokens_by_collection
    result = {}
    self.tokens.each do |token|
      if result[token.collection].nil?
        result[token.collection] = []
      end

      result[token.collection] << token
    end

    result
  end

  def explorer_url
    self.blockchain.explorer_address_url + self.address
  end

end
