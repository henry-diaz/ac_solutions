class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :contactable, polymorphic: true
      t.integer :active, default: 1
      t.string :first_name
      t.string :last_name
      t.belongs_to :charge
      t.string :phone
      t.string :email
      t.timestamps
    end
    add_index :contacts, :active
    add_index :contacts, [:contactable_id, :contactable_type]
    add_index :contacts, [:contactable_type, :contactable_id]
    add_index :contacts, :charge_id
  end
end
