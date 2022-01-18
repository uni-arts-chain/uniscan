class AddIndexToTokens2 < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :bad, :integer, default: 0
    add_index :tokens, :bad
    add_index :tokens, [:collection_id, :bad]
  end
end
