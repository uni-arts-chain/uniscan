class AddImageSizeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :image_size, :integer, default: 0
  end
end
