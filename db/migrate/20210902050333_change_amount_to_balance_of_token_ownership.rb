class ChangeAmountToBalanceOfTokenOwnership < ActiveRecord::Migration[6.1]
  def change
    rename_column :token_ownerships, :amount, :balance
  end
end
