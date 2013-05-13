class AddKindToPurchasesAndSales < ActiveRecord::Migration
  def change
    add_column :purchases, :kind, :string, default: :bill
    add_column :sales, :kind, :string, default: :bill
    add_column :sales, :number, :integer
  end
end
