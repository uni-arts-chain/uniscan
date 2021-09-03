class AddTokenUriErrToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :token_uri_err, :text
  end
end
