class RemoveExplorerUrlFromTokens < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :explorer_url
  end
end
