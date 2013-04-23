class CreateAdjustments < ActiveRecord::Migration
  def change
    create_table :adjustments do |t|
      t.date :adjustment_date
      t.belongs_to :sku
      t.belongs_to :user
      t.integer :quantity
      t.string :comment
      t.timestamps
    end
    add_index :adjustments, :sku_id
    add_index :adjustments, :user_id
  end
end
