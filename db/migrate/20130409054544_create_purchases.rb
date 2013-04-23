class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :status, default: 0
      t.date :purchase_date
      t.string :number
      t.string :comment
      t.integer :items_count, default: 0
      t.timestamps
    end
    add_index :purchases, :number
  end
end
