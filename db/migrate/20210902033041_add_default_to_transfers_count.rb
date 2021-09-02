class AddDefaultToTransfersCount < ActiveRecord::Migration[6.1]
  def change
    change_column_default :collections, :transfers_count, from: nil, to: 0
    change_column_default :tokens, :transfers_count, from: nil, to: 0
  end
end
