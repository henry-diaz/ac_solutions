class Transaction < ActiveRecord::Base
  attr_accessible :transaction_date, :sku, :initial_inventory, :ending_inventory, :sales, :purchases, :adjustments, :amount

  # relations
  belongs_to :sku
  belongs_to :user
end
