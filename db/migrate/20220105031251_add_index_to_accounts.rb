class AddIndexToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_index :accounts, [:address, :blockchain_id], unique: true
  end
end
