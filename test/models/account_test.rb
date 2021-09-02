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
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should not save account without address" do
    account = Account.new blockchain_id: 0
    assert_not account.save, "Saved the account without a address"
  end

  test "should not save account without blockchain_id" do
    account = Account.new address: "0x"
    assert_not account.save, "Saved the account without a blockchain_id"
  end
end
