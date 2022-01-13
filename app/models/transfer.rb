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
#  timestamp         :integer
#
class Transfer < ApplicationRecord
  belongs_to :collection, counter_cache: true
  belongs_to :token, counter_cache: true
  belongs_to :from, class_name: "Account", foreign_key: "from"
  belongs_to :to, class_name: "Account", foreign_key: "to"

  # validates_uniqueness_of :txhash, scope: [:contract_address, :token_id_on_chain, :from, :to]

  after_create( 
    # :update_balances, 
    # :update_token_last_transfer_time,
    :update_token_transfers_count_7d,
    :update_token_transfers_count_24h
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
        .where(
          "contract_address=? and token_id_on_chain=? and timestamp>?", 
          self.contract_address, self.token_id_on_chain, self.timestamp - 604800
        )
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
        .where(
          "contract_address=? and token_id_on_chain=? and timestamp>?", 
          self.contract_address, self.token_id_on_chain, self.timestamp - 86400
        )
        .count

      self.token.update(transfers_count_24h: count)
    end
  end

  def self.create_transfer(blockchain, block_number, contract_address, txhash, from, to, timestamp, token_id, token_uri, name, symbol)
    a0 = Time.now
    blockchain = Blockchain.find_by_name(blockchain)
    return if blockchain.blank?

            a1 = Time.now
    collection = Collection.find_by_contract_address(contract_address)
    if collection.blank?
      raise "contract_address #{contract_address} not exist"
    else
      collection.update(
        name: name,
        symbol: symbol
      )
    end
    
            a2 = Time.now
    from_account = Account.find_by(address: from, blockchain_id: blockchain.id)
    if from_account.blank?
      from_account = Account.create(
        address: from,
        blockchain_id: blockchain.id
      )
    end

    to_account = Account.find_by(address: to, blockchain_id: blockchain.id)
    if to_account.blank?
      to_account = Account.create(
        address: to,
        blockchain_id: blockchain.id
      )
    end

            a3 = Time.now
    token = Token.find_by(contract_address: contract_address, token_id_on_chain: token_id)
    if token.blank?
      raise "token #{contract_address}-#{token_id} not exist"
    else
      token.update({owner: to_account})
    end
            a4 = Time.now

    Transfer.create(
      collection: collection,
      token: token,
      contract_address: contract_address,
      token_id_on_chain: token_id,
      from: from_account,
      from_address: from,
      to: to_account,
      to_address: to,
      timestamp: timestamp,
      block_number: block_number,
      txhash: txhash,
      amount: 1
    )

    a5 = Time.now
    puts "0: #{a1-a0}"
    puts "1: #{a2-a1}"
    puts "2: #{a3-a2}"
    puts "3: #{a4-a3}"
    puts "4: #{a5-a4}"
  end
end
