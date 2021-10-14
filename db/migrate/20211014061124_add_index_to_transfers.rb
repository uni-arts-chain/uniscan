class AddIndexToTransfers < ActiveRecord::Migration[6.1]
  def change
    add_index :transfers, 
      [:collection_id, :token_id, :from, :to, :txhash], 
      unique: true,
      name: 'transfers_uniq_index'
  end
end
