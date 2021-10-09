class ChangeImageUrlToImageUriOfTokens < ActiveRecord::Migration[6.1]
  def change
    rename_column :tokens, :image_url, :image_uri
  end
end
