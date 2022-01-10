class CreateTokensInfos < ActiveRecord::Migration[6.1]
  def up
    create_table :tokens_infos do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :tokens_infos, :key, unique: true

    TokensInfo.create(key: "last_token_mint_time", value: nil)
    TokensInfo.create(key: "tokens_count", value: "0")
    TokensInfo.create(key: "ctrl", value: "0") # 1: stop
  end

  def down
    drop_table :tokens_infos
  end
end
