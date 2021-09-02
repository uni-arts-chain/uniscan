class AddDefaultToHoldersOfCollection < ActiveRecord::Migration[6.1]
  def change
    change_column_default :collections, :holders, from: nil, to: 0
  end
end
