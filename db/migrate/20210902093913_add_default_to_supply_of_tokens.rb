class AddDefaultToSupplyOfTokens < ActiveRecord::Migration[6.1]
  def change
    change_column_default :tokens, :supply, from: nil, to: 1
  end
end
