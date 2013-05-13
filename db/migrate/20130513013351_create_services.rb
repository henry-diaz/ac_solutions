class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :active, default: 1
      t.string :code
      t.string :name
      t.text :description
      t.decimal :unit_price, precision: 8, scale: 2, default: 0
      t.timestamps
    end
  end
end
