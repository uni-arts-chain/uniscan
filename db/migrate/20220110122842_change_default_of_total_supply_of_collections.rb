class ChangeDefaultOfTotalSupplyOfCollections < ActiveRecord::Migration[6.1]
  def change
    change_column_default :collections, :total_supply, from: nil, to: 0
  end
end
