class AddImageOriContentTypeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :image_ori_content_type, :string
  end
end
