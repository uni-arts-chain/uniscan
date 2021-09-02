class AddCollectionIdToTokenOwnerships < ActiveRecord::Migration[6.1]
  def change
    add_column :token_ownerships, :collection_id, :integer
  end
end
