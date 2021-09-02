class ChangeTransferNumberToTransfersCount < ActiveRecord::Migration[6.1]
  def change
    rename_column :collections, :transfer_number, :transfers_count
    rename_column :tokens, :transfer_number, :transfers_count
  end
end
