# == Schema Information
#
# Table name: blockchains
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  testnet              :boolean          default(FALSE)
#  explorer_token_url   :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  explorer_address_url :string(255)
#
require "test_helper"

class BlockchainTest < ActiveSupport::TestCase
  test "should not save blockchain without name" do
    blockchain = Blockchain.new
    assert_not blockchain.save, "Saved the blockchain without a name"
  end

  test "should not save blockchain with a name that already exists" do
    blockchain1 = Blockchain.new name: 'Darwinia'
    assert blockchain1.save
    blockchain2 = Blockchain.new name: 'Darwinia'
    assert_not blockchain2.save, "Saved the blockchain with a name that already exists"
  end

end
