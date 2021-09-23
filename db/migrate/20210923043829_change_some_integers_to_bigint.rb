class ChangeSomeIntegersToBigint < ActiveRecord::Migration[6.1]
  def up 
    change_column :transfers, :amount, :bigint
    change_column :tokens, :supply, :bigint
    change_column :collections, :supply, :bigint
    change_column :collections, :total_supply, :bigint
    change_column :token_ownerships, :balance, :bigint
  end

  def down
    change_column :transfers, :amount, :integer
    change_column :tokens, :supply, :integer
    change_column :collections, :supply, :integer
    change_column :collections, :total_supply, :integer
    change_column :token_ownerships, :balance, :integer
  end
end
