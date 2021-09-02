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
require "test_helper"

class TokenOwnershipTest < ActiveSupport::TestCase
  test "collection holders count can be changed correctly" do
    assert_equal tokens[0].collection.holders_count, 0

    TokenOwnership.create(
      token: tokens[0], # <--- token one
      account: accounts[0]
    )

    assert_equal tokens[0].collection.holders_count, 1

    t = TokenOwnership.create(
      token: tokens[0], # <--- token one
      account: accounts[1]
    )
    TokenOwnership.create(
      token: tokens[1],
      account: accounts[1]
    )

    assert_equal tokens[0].collection.holders_count, 2

    t.update balance: 0

    assert_equal TokenOwnership.count, 3
    assert_equal 2, tokens[0].collection.holders_count
  end

  test "token holders count can be changed correctly" do
    assert_equal tokens[0].holders_count, 0

    TokenOwnership.create(
      token: tokens[0],
      account: accounts[0]
    )

    assert_equal tokens[0].holders_count, 1

    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[1]
    )

    assert_equal tokens[0].holders_count, 2

    t.update balance: 0

    assert_equal TokenOwnership.count, 2
    assert_equal tokens[0].holders_count, 1
  end

  test "token supply calc correctly 1" do
    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[0]
    )

    assert_equal tokens[0].supply, 1

    t.destroy

    assert_equal tokens[0].supply, 0
  end

  test "token supply calc correctly 2" do
    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[0],
      balance: 99
    )

    assert_equal tokens[0].supply, 99

    t.update balance: 199

    assert_equal tokens[0].supply, 199

    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[1],
      balance: 1
    )

    assert_equal tokens[0].supply, 200

    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[1],
      balance: -1
    )

    assert_equal 200, tokens[0].supply 
  end

  test "collection total_supply calc correctly" do
    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[0],
      balance: 99
    )

    assert_equal 99, tokens[0].collection.total_supply

    t.update balance: 199

    assert_equal 199, tokens[0].collection.total_supply
  end

  test "unique by token and account" do
    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[0],
    )

    t = TokenOwnership.create(
      token: tokens[0],
      account: accounts[0],
    )

    assert_equal "Token should be unique under an account", t.errors.full_messages[0]
    assert_equal 1, TokenOwnership.count
  end
end
