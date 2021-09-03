class AddInvalidatedToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :invalidated, :bool, default: false
    add_column :tokens, :invalidated_reason, :integer
  end
end
