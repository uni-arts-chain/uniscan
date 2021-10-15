# == Schema Information
#
# Table name: transfers
#
#  id            :bigint           not null, primary key
#  collection_id :integer
#  token_id      :integer
#  amount        :decimal(65, )    default(1)
#  from          :integer
#  to            :integer
#  block_number  :integer
#  txhash        :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class TransferTest < ActiveSupport::TestCase
  test "transfer creation will change token ownerships" do
    # transfer 1
    transfer = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480",
      amount: 99
    )

    t_from = TokenOwnership.find_by account: accounts[0], token: tokens[0]
    assert_equal t_from.balance, -99

    t_to = TokenOwnership.find_by account: accounts[1], token: tokens[0]
    assert_equal t_to.balance, 99

    assert_equal TokenOwnership.count, 2

    # transfer 2
    transfer = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[1],
      to: accounts[0],
      block_number: 12994591,
      txhash: "0x0fc19e197956bfaf93420c603c7431bb7b51eb6aa9d92678867ea6bd9f67c6d6",
      amount: 9
    )

    t_from = TokenOwnership.find_by account: accounts[1], token: tokens[0]
    assert_equal t_from.balance, 90

    t_to = TokenOwnership.find_by account: accounts[0], token: tokens[0]
    assert_equal t_to.balance, -90

    assert_equal TokenOwnership.count, 2

    # transfer 3
    transfer = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[1],
      to: accounts[0],
      block_number: 12994592,
      txhash: "0x0fc19e197956bfaf93420c603c7431bb7b51eb6aa9d92678867ea6bd9f67c6d6",
      amount: 90
    )

    t_from = TokenOwnership.find_by account: accounts[1], token: tokens[0]
    assert_nil t_from

    t_to = TokenOwnership.find_by account: accounts[0], token: tokens[0]
    assert_nil t_to

    assert_equal TokenOwnership.count, 0
  end

  test "transfer creation will change token ownerships 2" do
    transfer = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480",
      amount: 1
    )

    t_from = TokenOwnership.find_by account: accounts[0], token: tokens[0]
    assert_equal t_from.balance, -1

    t_to = TokenOwnership.find_by account: accounts[1], token: tokens[0]
    assert_equal t_to.balance, 1

    assert_equal TokenOwnership.count, 2
  end

  test "transfers count for collections" do
    assert_equal collections[0].transfers_count, 0

    transfer = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480",
      amount: 1
    )

    assert_equal collections[0].transfers_count, 1
  end

  test "should not create a new record with same info" do
    Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480",
      amount: 1
    )

    t1 = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x6bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480", # <- changed
      amount: 1
    )
    assert t1.errors.empty?

    t2 = Transfer.create(
      collection: collections[0],
      token: tokens[0],
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480", # <- same
      amount: 1
    )
    assert_equal t2.errors.full_messages[0], "Txhash has already been taken"
  end

  test "update token's transfers count after a transfer created" do
    token = tokens[0]

    assert_equal token.transfers_count, 0
    assert_equal token.transfers_count_24h, 0
    assert_equal token.transfers_count_7d, 0

    Transfer.create(
      collection: collections[0],
      token: token,
      from: accounts[0],
      to: accounts[1],
      block_number: 12994590,
      txhash: "0x4bdc7b8f1a9ca6fffe16fe2a8d543fc9c491f0e5a54954562afe5f819c261480",
      amount: 1
    )

    assert_equal token.transfers_count, 1
    assert_equal token.transfers_count_24h, 1
    assert_equal token.transfers_count_7d, 1
  end
end
