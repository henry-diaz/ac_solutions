class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :customer
      t.string :name
      t.text :description
      t.text :address
      t.datetime :start_at
      t.datetime :end_at
      t.belongs_to :user
      t.integer :come, default: 1
      t.timestamps
    end
    add_index :appointments, :customer_id
    add_index :appointments, :user_id

    create_table :appointments_users, id: false do |t|
      t.belongs_to :appointment
      t.belongs_to :user
    end
    add_index :appointments_users, [:appointment_id, :user_id]
  end
end
