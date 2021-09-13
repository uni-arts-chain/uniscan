class AddTokenUriParsedToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :token_uri_parsed, :boolean, default: false
  end
end
