class ChangeCommentsFieldFromSalesToText < ActiveRecord::Migration
  def up
    change_column :sales, :comment, :text
  end

  def down
    change_column :sales, :comment, :string
  end
end
