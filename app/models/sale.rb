class Sale < ActiveRecord::Base
  attr_accessible :customer_id, :comment

  # relations
  has_many :items, as: :resourceable, dependent: :destroy
  belongs_to :customer
end
