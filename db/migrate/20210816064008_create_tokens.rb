class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :token_id
      t.integer :collection_id
      t.boolean :unique, default: true
      t.integer :supply
      t.integer :creator_id
      t.integer :owner_id
      t.string :name
      t.string :description
      t.string :image
      t.text :token_uri
      t.boolean :is_permanent
      t.string :explorer_url
      t.integer :transfer_number

      t.timestamps
    end
  end
end
