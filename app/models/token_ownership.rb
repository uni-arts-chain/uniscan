# == Schema Information
#
# Table name: token_ownerships
#
#  id            :bigint           not null, primary key
#  token_id      :integer
#  account_id    :integer
#  balance       :integer          default(1)
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

  # token_id, account_id, balance, collection_id
  # 22,       15,         1,       9            <--- this token_ownership committed
  # 24,       17,         1,       9
  # 22,       16,         2,       9
  after_commit(
    :update_collection_holders, # 3
    :update_collection_supply, # 2, how many tokens

    :update_token_holders, # 2
    :update_token_supply # 3, supply of a token
  )

  def update_collection_holders
    holders_count = TokenOwnership.
      where(collection: self.collection).
      where("balance > 0").
      count
    self.collection.update holders_count: holders_count
  end

  def update_collection_supply
    supply = TokenOwnership.
      where(collection: self.collection).
      where("balance > 0").
      distinct.
      count(:token_id)
    self.collection.update supply: supply
  end

  def update_token_holders
    holders_count = TokenOwnership.
      where(token: self.token).
      where("balance > 0").
      count
    self.token.update holders_count: holders_count
  end

  def update_token_supply
    supply = TokenOwnership.
      where(token: self.token).
      where("balance > 0").
      sum(:balance)
    self.token.update supply: supply
  end

end
