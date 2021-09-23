class ChangeSomeIntegersToBigint < ActiveRecord::Migration[6.1]
  def up 
    change_column :transfers, :amount, :decimal, precision: 65, scale: 0
    change_column :tokens, :supply, :decimal, precision: 65, scale: 0
    change_column :collections, :supply, :decimal, precision: 65, scale: 0
    change_column :collections, :total_supply, :decimal, precision: 65, scale: 0
    change_column :token_ownerships, :balance, :decimal, precision: 65, scale: 0
  end

  def down
    change_column :transfers, :amount, :integer
    change_column :tokens, :supply, :integer
    change_column :collections, :supply, :integer
    change_column :collections, :total_supply, :integer
    change_column :token_ownerships, :balance, :integer
  end
end
