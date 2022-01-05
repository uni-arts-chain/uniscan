class AddIndexToCollections < ActiveRecord::Migration[6.1]
  def change
    add_index :collections, :contract_address, unique: true
  end
end
