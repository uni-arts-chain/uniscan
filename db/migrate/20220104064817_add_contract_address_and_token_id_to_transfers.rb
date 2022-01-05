class AddContractAddressAndTokenIdToTransfers < ActiveRecord::Migration[6.1]
  def change
    add_column :transfers, :contract_address, :string
    add_column :transfers, :token_id_on_chain, :string
  end
end
