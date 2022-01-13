class ChangeTransfers < ActiveRecord::Migration[6.1]
  def up
    remove_index :transfers, name: 'transfers_uniq_index2'
    add_column :transfers, :timestamp, :integer
    add_column :transfers, :from_address, :string
    add_column :transfers, :to_address, :string
    add_index :transfers, [:contract_address, :token_id_on_chain, :timestamp], name: "transfers_index3"
  end

  def down
    remove_index :transfers, name: "transfers_index3"
    remove_column :transfers, :to_address
    remove_column :transfers, :from_address
    remove_column :transfers, :timestamp
    add_index :transfers, 
      [:contract_address, :token_id_on_chain, :from, :to, :txhash], 
      unique: true,
      name: 'transfers_uniq_index2'
  end
end
