class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :address, uniq: true
      t.integer :blockchain_id
      t.integer :level, default: 0

      t.timestamps
    end
  end
end
