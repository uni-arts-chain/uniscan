class ChangeIsPermanentToIpfsOfTokens < ActiveRecord::Migration[6.1]
  def change
    rename_column :tokens, :is_permanent, :ipfs
    change_column_default :tokens, :ipfs, from: nil, to: false
  end
end
