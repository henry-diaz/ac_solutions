class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.belongs_to :phoneable, polymorphic: true
      t.string :number
      t.timestamps
    end
    add_index :phones, [:phoneable_id, :phoneable_type]
    add_index :phones, [:phoneable_type, :phoneable_id]
  end
end
