class AddHoldersCountToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :holders_count, :integer, default: 0
  end
end
