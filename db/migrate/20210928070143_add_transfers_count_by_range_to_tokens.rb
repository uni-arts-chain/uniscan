class AddTransfersCountByRangeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :transfers_count_24h, :integer, default: 0
    add_column :tokens, :transfers_count_7d, :integer, default: 0
  end
end
