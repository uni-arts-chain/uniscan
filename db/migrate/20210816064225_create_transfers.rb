class CreateTransfers < ActiveRecord::Migration[6.1]
  def change
    create_table :transfers do |t|
      t.integer :collection_id
      t.integer :token_id
      t.integer :amount, default: 1
      t.integer :from
      t.integer :to
      t.integer :block_number
      t.string :txhash

      t.timestamps
    end
  end
end
