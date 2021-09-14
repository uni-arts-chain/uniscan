class AddExplorerAddressUrlToBlockchains < ActiveRecord::Migration[6.1]
  def change
    add_column :blockchains, :explorer_address_url, :string
    rename_column :blockchains, :explorer_base_url, :explorer_token_url
  end
end
