class ChangeNameTypeOfTokens < ActiveRecord::Migration[6.1]
  def up
    change_column :tokens, :name, :text
  end

  def down
    change_column :tokens, :name, :string
  end
end
