# If it is an erc721 transfer on chain, it will generate a transfer record.
# {https://github.com/uni-arts-chain/evm-nft-tracker/#erc-721}
#
# If it is an erc1155 transfer on chain, it may generate a transfer record, 
# or it may generate multiple transfer records.
# {https://github.com/uni-arts-chain/evm-nft-tracker/#erc---1155}
#
# The +amount+ field indicates the amount of transfer. 
# The +amount+ field of erc721 transfer will only be 1. 
# The +amount+ field of erc1155 transfer may be any value greater than or 
# equal to 1 (less than 2**256).
#
# Unique index: <tt>[:collection_id, :token_id, :from, :to, :txhash]</tt>
#
# == Schema Information
#
# Table name: transfers
#
#  id                :bigint           not null, primary key
#  collection_id     :integer
#  token_id          :integer
#  amount            :decimal(65, )    default(1)
#  from              :integer
#  to                :integer
#  block_number      :integer
#  txhash            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  contract_address  :string(255)
#  token_id_on_chain :string(255)
#
class Transfer < ApplicationRecord
  belongs_to :collection, counter_cache: true
  belongs_to :token, counter_cache: true
  belongs_to :from, class_name: "Account", foreign_key: "from"
  belongs_to :to, class_name: "Account", foreign_key: "to"

  # validates_uniqueness_of :txhash, scope: [:contract_address, :token_id_on_chain, :from, :to]

  after_create( 
    :update_balances, 
    :update_token_last_transfer_time
    # :update_token_transfers_count_7d,
    # :update_token_transfers_count_24h
  )

  # Update the transfer's token's balances of the +from+ and +to+ account.
  #
  # This method will be called after a new transfer record is created.
  #
  # Excluding 0x0 address.
  def update_balances
    if self.token
      # sub `from` account balance
      unless self.from.address == "0x0000000000000000000000000000000000000000" # if not mint
        token_ownership = TokenOwnership.find_by(account: self.from, token: self.token)
        if token_ownership.present?
          token_ownership.update balance: token_ownership.balance - self.amount
        else
          TokenOwnership.create(
            account: self.from,
            token: token,
            balance: -self.amount
          )
        end
      end

      # add `to` account balance
      unless self.to.address == "0x0000000000000000000000000000000000000000" # if not burn
        token_ownership = TokenOwnership.find_by(account: self.to, token: self.token)
        if token_ownership.present?
          token_ownership.update balance: token_ownership.balance + self.amount
        else
          TokenOwnership.create(
            account: self.to,
            token: token,
            balance: self.amount
          )
        end
      end
    end
  end

  # Update the last transfer time of the token.
  #
  # This method will be called after a new transfer record is created.
  def update_token_last_transfer_time
    if self.token
      self.token.update(
        last_transfer_time: self.created_at
      )
    end
  end

  # Update the transfers count of latest 7 days of the token.
  #
  # This method will be called after a new transfer record is created.
  def update_token_transfers_count_7d
    if self.token
      count = Transfer
        .where(token: self.token)
        .where('created_at >= ?', 1.week.ago)
        .count

      self.token.update(transfers_count_7d: count)
    end
  end

  # Update the transfers count of latest 24 hours of the token.
  #
  # This method will be called after a new transfer record is created.
  def update_token_transfers_count_24h
    if self.token
      count = Transfer
        .where(token: self.token)
        .where('created_at >= ?', 1.day.ago)
        .count

      self.token.update(transfers_count_24h: count)
    end
  end
end
