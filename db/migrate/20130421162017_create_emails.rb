class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.belongs_to :emailable, polymorphic: true
      t.string :address
      t.timestamps
    end
    add_index :emails, [:emailable_id, :emailable_type]
    add_index :emails, [:emailable_type, :emailable_id]
  end
end
