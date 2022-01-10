class AddIndexToTokens < ActiveRecord::Migration[6.1]
  def change
    add_index :tokens, [:contract_address, :token_id_on_chain]
  end
end
