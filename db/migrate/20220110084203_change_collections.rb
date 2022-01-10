class ChangeCollections < ActiveRecord::Migration[6.1]
  def up
    add_column :collections, :metadata, :boolean
    change_column :collections, :name, :text
    change_column :collections, :symbol, :text
  end

  def down
    change_column :collections, :symbol, :string
    change_column :collections, :name, :string
    remove_column :collections, :metadata
  end
end
