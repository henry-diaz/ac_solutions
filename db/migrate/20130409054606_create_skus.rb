class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.integer :active, default: 1
      t.belongs_to :category
      t.string :code
      t.string :name
      t.decimal :unit_price, precision: 8, scale: 2, default: 0
      t.integer :quantity
      t.timestamps
    end
    add_index :skus, :active
    add_index :skus, :code
    add_index :skus, :name
    add_index :skus, :category_id
  end
end
