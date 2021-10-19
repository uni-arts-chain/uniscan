class ChangeImageUriTypeOfTokens < ActiveRecord::Migration[6.1]
  def up
    change_column :tokens, :image_uri, :text
  end

  def down
    change_column :tokens, :image_uri, :string
  end
end
