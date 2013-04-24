class Sale < ActiveRecord::Base
  attr_accessible :customer_id, :comment, :sale_date

  # relations
  has_many :items, as: :resourceable, dependent: :destroy
  belongs_to :customer

  # validations
  validates :sale_date, presence: true

  # delegates
  delegate :name, to: :customer, prefix: true, allow_nil: true
  delegate :code, to: :customer, prefix: true, allow_nil: true

  # methods
  def total
    items.map(&:subtotal).inject(:+) || 0
  end
end
