class Purchase < ActiveRecord::Base
  attr_accessible :number, :comment, :purchase_date

  # relations
  has_many :items, as: :resourceable, dependent: :destroy

  # validations
  validates :number, presence: true, uniqueness: true
  validates :purchase_date, presence: true

  # methods
  def total
    items.map(&:subtotal).inject(:+) || 0
  end
end
