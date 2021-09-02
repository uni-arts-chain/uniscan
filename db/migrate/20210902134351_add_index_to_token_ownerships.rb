class AddIndexToTokenOwnerships < ActiveRecord::Migration[6.1]
  def change
    add_index :token_ownerships, [:account_id, :token_id], unique: true
  end
end
