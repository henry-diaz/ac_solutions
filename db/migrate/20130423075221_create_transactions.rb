class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :transaction_date
      t.belongs_to :sku
      t.belongs_to :user
      t.integer :initial_inventory
      t.integer :ending_inventory
      t.integer :sales
      t.integer :purchases
      t.integer :adjustments
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.timestamps
    end
    add_index :transactions, :sku_id
    add_index :transactions, :user_id
  end
end
