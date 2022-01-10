class ChangeTokens < ActiveRecord::Migration[6.1]
  def up
    add_column :tokens, :mint_time, :integer
    add_column :tokens, :contract_address, :string
    change_column :tokens, :token_uri, :text, limit: 16.megabytes - 1
  end

  def down
    change_column :tokens, :token_uri, :text
    remove_column :tokens, :contract_address
    remove_column :tokens, :mint_time
  end
end
