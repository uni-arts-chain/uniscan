class ChangeImageToImageUrlOfTokens < ActiveRecord::Migration[6.1]
  def change
    rename_column :tokens, :image, :image_url
  end
end
