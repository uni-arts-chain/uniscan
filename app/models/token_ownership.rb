# The token is owned by account. This table records the ownership 
# relationship between them.
#
# The +balance+ records how many tokens the account has. ERC1155 will be more 
# than 1.
#
# The +balance+ may be negative because the system does not start at the beginning
# of the blockchain.
#
# TokenOwnership's update will update 
# 1. token's holders and supply. 
# 2. collection's holders and supply.
#
# For example:
#   token_id, account_id, balance, collection_id
#   24        17          1        9
#   22        16          2        9
#   22        15          1        9            <--- this token_ownership committed
# The token 22's holders will be 2.  
# The token 22's supply will be 3.  
# The collection 9's holders will be 3.  
# The collection 9's supply will be 2.
#
# == Schema Information
#
# Table name: token_ownerships
#
#  id            :bigint           not null, primary key
#  token_id      :integer
#  account_id    :integer
#  balance       :decimal(65, )    default(1)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :integer
#
class TokenOwnership < ApplicationRecord
  belongs_to :account
  belongs_to :token

  validates :token, uniqueness: { scope: :account,
    message: "should be unique under an account" }

  belongs_to :collection

  before_validation do
    self.collection = self.token.collection
  end

  after_commit(
    :update_collection_holders,
    :update_collection_supply,

    :update_token_holders,
    :update_token_supply
  )

  # Update the collection's holders count.
  #
  # This method will be called after the token_ownership's record is created or
  # updated.
  def update_collection_holders
    holders_count = TokenOwnership.
      where(collection: self.collection).
      where("balance > 0").
      count
    self.collection.update holders_count: holders_count
  end

  # Update the collection's supply.
  #
  # This method will be called after the token_ownership's record is created or
  # updated.
  def update_collection_supply
    supply = TokenOwnership.
      where(collection: self.collection).
      where("balance > 0").
      distinct.
      count(:token_id)
    self.collection.update supply: supply
  end

  # Update the token's holders.
  #
  # This method will be called after the token_ownership's record is created or
  # updated.
  def update_token_holders
    holders_count = TokenOwnership.
      where(token: self.token).
      where("balance > 0").
      count
    self.token.update holders_count: holders_count
  end

  # Update the token's supply.
  #
  # This method will be called after the token_ownership's record is created or
  # updated.
  def update_token_supply
    supply = TokenOwnership.
      where(token: self.token).
      where("balance > 0").
      sum(:balance)
    self.token.update supply: supply
  end

end
