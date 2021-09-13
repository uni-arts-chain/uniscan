class RemoveCreatorIdFromTokens < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :creator_id, :integer
  end
end
