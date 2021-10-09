class ChangeTokenUriParsedToTokenUriProcessedOfTokens < ActiveRecord::Migration[6.1]
  def change
    rename_column :tokens, :token_uri_parsed, :token_uri_processed
  end
end
