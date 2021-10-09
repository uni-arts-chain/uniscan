# == Schema Information
#
# Table name: collections
#
#  id                   :bigint           not null, primary key
#  name                 :string(255)
#  symbol               :string(255)
#  blockchain_id        :integer
#  contract_platform    :integer          default("evm")
#  contract_address     :string(255)
#  nft_type             :integer          default("erc721")
#  total_supply         :decimal(65, )
#  holders_count        :integer          default(0)
#  transfers_count      :integer          default(0)
#  creator_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  supply               :decimal(65, )    default(0)
#  creator_address      :string(255)
#  created_at_block     :integer
#  created_at_timestamp :integer
#  created_at_tx        :string(255)
#
require "test_helper"

class CollectionTest < ActiveSupport::TestCase
  test 'has the right contract_platform index' do
    contract_platforms = [:evm, :wasm]
    contract_platforms.each_with_index do |item, index|
      assert_equal(Collection.contract_platforms[item], index)
    end
  end

  test 'has the right nft_type index' do
    nft_types = [:erc721, :erc1155]
    nft_types.each_with_index do |item, index|
      assert_equal(Collection.nft_types[item], index)
    end
  end

  test "should not save without blockchain_id" do
    collection = Collection.new contract_address: "0x"
    assert_not collection.save, "Saved the collection without a blockchain_id"
  end

  test "should not save without contract_address" do
    collection = Collection.new blockchain_id: 0
    assert_not collection.save, "Saved the collection without a contract_address"
  end
end
