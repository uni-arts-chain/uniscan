class ChangeTokenIdToTokenIdOnChain < ActiveRecord::Migration[6.1]
  def change
    rename_column :tokens, :token_id, :token_id_on_chain
  end
end
