class CreateCollectionsInfos < ActiveRecord::Migration[6.1]
  def up
    create_table :collections_infos do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :collections_infos, :key, unique: true

    CollectionsInfo.create(key: "last_token_contract_address", value: nil)
    CollectionsInfo.create(key: "token_contracts_count", value: "0")
    CollectionsInfo.create(key: "ctrl", value: "0") # 1: stop
  end
  
  def down
    drop_table :collections_infos
  end
end
