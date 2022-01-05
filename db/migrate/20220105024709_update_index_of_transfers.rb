class UpdateIndexOfTransfers < ActiveRecord::Migration[6.1]
  def change
    remove_index :transfers, name: 'transfers_uniq_index'
    add_index :transfers, 
      [:contract_address, :token_id_on_chain, :from, :to, :txhash], 
      unique: true,
      name: 'transfers_uniq_index2'
  end
end
