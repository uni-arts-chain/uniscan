class AddIndexToTokens2 < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :bad, :integer, default: 0
    add_index :tokens, :bad
  end
end
