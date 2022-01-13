# An account represents a blockchain account. It should has an address.
#
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
  # has_many :token_ownerships, -> { where('balance > 0') }
  # has_many :tokens, through: :token_ownerships

  validates :address, presence: true

  # Get all the tokens of this account. 
  # These tokens are classified according to the collection they belong to.
  #
  # This method is used by {AccountsController#show}.
  # @return [Array<HashMap<Collection, Array<Token>>>] tokens by collection
  def tokens_by_collection
    result = {}
    self.tokens.eligible.each do |token|
      if result[token.collection].nil?
        result[token.collection] = []
      end

      result[token.collection] << token
    end

    result
  end

  # Get the explorer url the account's address.
  #
  # @return [String]
  def explorer_url
    self.blockchain.explorer_address_url&.gsub("{address}", self.address)
  end

end
