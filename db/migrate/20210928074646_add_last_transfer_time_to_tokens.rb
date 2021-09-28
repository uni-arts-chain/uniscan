class AddLastTransferTimeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :last_transfer_time, :datetime
  end
end
