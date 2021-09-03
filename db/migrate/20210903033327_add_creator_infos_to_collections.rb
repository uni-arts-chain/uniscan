class AddCreatorInfosToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :creator_address, :string
    add_column :collections, :created_at_block, :integer
    add_column :collections, :created_at_timestamp, :integer
    add_column :collections, :created_at_tx, :string
  end
end
