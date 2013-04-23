class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :resourceable, polymorphic: true
      t.belongs_to :sku
      t.integer :quantity
      t.decimal :unit_price, precision: 8, scale: 2, default: 0
      t.timestamps
    end
    add_index :items, [:resourceable_id, :resourceable_type]
    add_index :items, :sku_id
  end
end
