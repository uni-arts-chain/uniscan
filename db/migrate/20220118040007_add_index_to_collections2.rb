class AddIndexToCollections2 < ActiveRecord::Migration[6.1]
  def change
    add_index :collections, [:collection_id, :bad]
  end
end
