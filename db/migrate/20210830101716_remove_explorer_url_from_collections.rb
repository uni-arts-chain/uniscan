class RemoveExplorerUrlFromCollections < ActiveRecord::Migration[6.1]
  def change
    remove_column :collections, :explorer_url
  end
end
