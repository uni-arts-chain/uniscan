class ChangeDescriptionTypeOfTokens < ActiveRecord::Migration[6.1]
  def up
    change_column :tokens, :description, :text
  end

  def down
    change_column :tokens, :description, :string
  end
end
