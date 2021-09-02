class AddSupplyToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :supply, :integer, default: 0
  end
end
