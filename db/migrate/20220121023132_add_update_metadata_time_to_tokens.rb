class AddUpdateMetadataTimeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :update_metadata_time, :datetime
  end
end
