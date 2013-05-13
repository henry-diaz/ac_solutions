class ChangeSkuIdToPolymorphicItemsTable < ActiveRecord::Migration
  def up
    add_column :items, :itemable_id, :integer
    add_column :items, :itemable_type, :string
    add_index :items, [:itemable_id, :itemable_type]
    Item.reset_column_information

    Item.find_in_batches do |items|
      items.each do |item|
        item.update_column(:itemable_id, item.sku_id)
        item.update_column(:itemable_type, "Sku")
      end
    end

    remove_column :items, :sku_id
  end

  def down
    add_column :items, :sku_id, :integer
    add_index :items, :sku_id
    Item.reset_column_information

    Item.find_in_batches do |items|
      items.each do |item|
        item.update_column(:sku_id, item.itemable_id)
      end
    end

    remove_column :items, :itemable_id
    remove_column :items, :itemable_type
  end
end
