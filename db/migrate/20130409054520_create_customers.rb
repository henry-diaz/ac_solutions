class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :active, default: 1
      t.string :code
      t.string :name
      t.string :kind
      t.text :description
      t.string :phone
      t.text :address
      t.timestamps
    end
    add_index :customers, :active
    add_index :customers, :name
    add_index :customers, :phone
    add_index :customers, :kind
  end
end
