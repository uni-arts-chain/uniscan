class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :name
      t.text :value
      t.integer :token_id

      t.timestamps
    end
  end
end
