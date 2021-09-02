class CreateTokenOwnerships < ActiveRecord::Migration[6.1]
  def change
    create_table :token_ownerships do |t|
      t.integer :token_id
      t.integer :account_id
      t.integer :amount, default: 1

      t.timestamps
    end
  end
end
