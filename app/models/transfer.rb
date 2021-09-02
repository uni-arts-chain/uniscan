# == Schema Information
#
# Table name: transfers
#
#  id            :bigint           not null, primary key
#  collection_id :integer
#  token_id      :integer
#  amount        :integer          default(1)
#  from          :integer
#  to            :integer
#  block_number  :integer
#  txhash        :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Transfer < ApplicationRecord
  belongs_to :collection, counter_cache: true
  belongs_to :token, counter_cache: true
  belongs_to :from, class_name: "Account", foreign_key: "from"
  belongs_to :to, class_name: "Account", foreign_key: "to"

  after_create :update_balances

  def update_balances
    # calc `from` account balance
    unless self.from.address == "0x0000000000000000000000000000000000000000" # if not mint
      Transfer.update_balance(self.from, self.token)
    end

    # calc `to` account balance
    unless self.to.address == "0x0000000000000000000000000000000000000000" # if not burn
      Transfer.update_balance(self.to, self.token)
    end
  end

  def self.update_balance(account, token)
      sub = Transfer.where(from: account, token: token).sum(:amount)
      add = Transfer.where(to: account, token: token).sum(:amount)
      balance = add - sub

      token_ownership = TokenOwnership.find_by(account: account, token: token)
      if token_ownership.present?

        if balance == 0
          token_ownership.destroy
        else
          token_ownership.update balance: balance
        end

      else
        
        if balance != 0
          TokenOwnership.create(
            account: account,
            token: token,
            balance: balance
          )
        end
      end
  end
end
