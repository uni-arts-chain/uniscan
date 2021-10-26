require 'test_helper'
class ProcessErc721EventWorkerTest < ActiveSupport::TestCase
  test "a new erc721 event added" do
    collection = Collection.find_by_contract_address "0xa56a4f2b9807311ac401c6afba695d3b0c31079d"
    assert_nil(collection)

    worker = ProcessErc721EventWorker.new
    worker.perform(
      blockchain: "Ethereum",
      block_number: 13110991,
      address: "0xa56a4f2b9807311ac401c6afba695d3b0c31079d",
      transaction_hash: "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7",
      from: "0x4c721c77190a44d640ff55be2699fe80a18ae730",
      to: "0x63141638f37c77e4ad0189b76d02607a0c80a1e7",
      token_id: "1544",
      token_uri: "https://api.monsterblocks.io/metadata/1544",
      name: "MonsterBlocks",
      symbol: "MONSTERBLOCK",
    )
    
    collection = Collection.find_by_contract_address "0xa56a4f2b9807311ac401c6afba695d3b0c31079d"
    assert(collection)

    account1 = Account.find_by_address "0x4c721c77190a44d640ff55be2699fe80a18ae730"
    assert(account1)
    account2 = Account.find_by_address "0x63141638f37c77e4ad0189b76d02607a0c80a1e7"
    assert(account2)

    token = Token.find_by(token_id_on_chain: "1544")
    assert(token)

    transfer = Transfer.find_by(collection: collection, token: token, from: account1, to: account2)
    assert(transfer)

    assert_equal(collection.contract_address, "0xa56a4f2b9807311ac401c6afba695d3b0c31079d")
    assert_equal(collection.name, "MonsterBlocks")
    assert_equal(collection.symbol, "MONSTERBLOCK")
    assert_equal(collection.blockchain.name, "Ethereum")
    assert_equal(collection.explorer_url, "https://etherscan.io/token/0xa56a4f2b9807311ac401c6afba695d3b0c31079d")
    assert_equal(token.token_id_on_chain, "1544")
    assert_equal(token.token_uri,  "https://api.monsterblocks.io/metadata/1544")
    assert_equal(transfer.block_number, 13110991)
    assert_equal(transfer.txhash, "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7")
    assert_equal(transfer.from.address, "0x4c721c77190a44d640ff55be2699fe80a18ae730")
    assert_equal(transfer.to.address, "0x63141638f37c77e4ad0189b76d02607a0c80a1e7")
  end

  test "an unsupported blockchain" do 
    collection = Collection.find_by_contract_address "0xa56a4f2b9807311ac401c6afba695d3b0c31079d"
    assert_nil(collection)

    worker = ProcessErc721EventWorker.new
    worker.perform(
      blockchain: "Hello",
      block_number: 13110991,
      address: "0xa56a4f2b9807311ac401c6afba695d3b0c31079d",
      transaction_hash: "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7",
      from: "0x4c721c77190a44d640ff55be2699fe80a18ae730",
      to: "0x63141638f37c77e4ad0189b76d02607a0c80a1e7",
      token_id: "1544",
      token_uri: "https://api.monsterblocks.io/metadata/1544",
      name: "MonsterBlocks",
      symbol: "MONSTERBLOCK",
    )
    collection = Collection.find_by_contract_address "0xa56a4f2b9807311ac401c6afba695d3b0c31079d"
    assert_nil(collection)
  end

  test "an event which has been received" do
    assert_equal(1, Collection.count)
    assert_equal(2, Token.count)
    assert_equal(2, Account.count)

    worker = ProcessErc721EventWorker.new

    worker.perform(
      blockchain: "Ethereum",
      block_number: 13110991,
      address: "0xa56a4f2b9807311ac401c6afba695d3b0c31079d",
      transaction_hash: "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7",
      from: "0x4c721c77190a44d640ff55be2699fe80a18ae730", # <---- already exist
      to: "0x63141638f37c77e4ad0189b76d02607a0c80a1e7", # <---- already exist
      token_id: "1544",
      token_uri: "https://api.monsterblocks.io/metadata/1544",
      name: "MonsterBlocks",
      symbol: "MONSTERBLOCK",
    )

    assert_equal(2, Collection.count)
    assert_equal(3, Token.count)
    assert_equal(2, Account.count)

    worker.perform(
      blockchain: "Ethereum",
      block_number: 13110991,
      address: "0xa56a4f2b9807311ac401c6afba695d3b0c31079d",
      transaction_hash: "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7",
      from: "0x4c721c77190a44d640ff55be2699fe80a18ae730", # <---- already exist
      to: "0x63141638f37c77e4ad0189b76d02607a0c80a1e7", # <---- already exist
      token_id: "1544",
      token_uri: "https://api.monsterblocks.io/metadata/1544",
      name: "MonsterBlocks",
      symbol: "MONSTERBLOCK",
    )

    assert_equal(2, Collection.count)
    assert_equal(3, Token.count)
    assert_equal(2, Account.count)
    assert_equal(1, Transfer.count)
  end

end
