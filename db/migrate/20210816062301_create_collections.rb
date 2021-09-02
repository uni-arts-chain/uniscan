class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections do |t|
      t.string :name
      t.string :symbol
      t.integer :blockchain_id
      t.integer :contract_platform, default: 0
      t.string :contract_address
      t.integer :nft_type, default: 0
      t.integer :total_supply
      t.string :explorer_url
      t.integer :holders
      t.integer :transfer_number
      t.integer :creator_id

      t.timestamps
    end
  end
end
