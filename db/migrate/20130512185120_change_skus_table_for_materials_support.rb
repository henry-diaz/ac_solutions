class ChangeSkusTableForMaterialsSupport < ActiveRecord::Migration
  def up
    add_column :skus, :kind, :string, default: :product
  end

  def down
    remove_column :skus, :kind
  end
end
