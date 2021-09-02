class CreateBlockchains < ActiveRecord::Migration[6.1]
  def change
    create_table :blockchains do |t|
      t.string :name
      t.boolean :testnet, default: false
      t.string :explorer_base_url

      t.timestamps
    end
  end
end
