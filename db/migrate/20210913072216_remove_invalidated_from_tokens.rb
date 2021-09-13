class RemoveInvalidatedFromTokens < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :invalidated, :boolean
    remove_column :tokens, :invalidated_reason, :integer
  end
end
