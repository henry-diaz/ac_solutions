class CreateLiquidateds < ActiveRecord::Migration
  def change
    create_table :liquidateds do |t|
      t.date :liquidated_date
      t.timestamps
    end
  end
end
