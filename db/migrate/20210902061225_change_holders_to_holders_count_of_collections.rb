class ChangeHoldersToHoldersCountOfCollections < ActiveRecord::Migration[6.1]
  def change
    rename_column :collections, :holders, :holders_count
  end
end
