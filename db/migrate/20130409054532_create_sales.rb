class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :status, default: 0
      t.date :sale_date
      t.belongs_to :customer
      t.string :comment
      t.integer :items_count, default: 0
      t.timestamps
    end
    add_index :sales, :customer_id
  end
end
