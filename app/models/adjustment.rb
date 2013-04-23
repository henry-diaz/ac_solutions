class Adjustment < ActiveRecord::Base
  attr_accessible :adjustment_date, :sku_id, :user_id, :quantity, :comment, :user

  # relations
  belongs_to :sku
  belongs_to :user
end
