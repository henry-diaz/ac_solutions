class Item < ActiveRecord::Base
  attr_accessible :sku_id, :quantity, :unit_price, :resourceable

  # relations
  belongs_to :resourceable, polymorphic: true, counter_cache: true
  belongs_to :sku

  # validations
  validates :sku_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 1000000, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }

  # delegates
  delegate :code, to: :sku, prefix: true, allow_nil: true
  delegate :name, to: :sku, prefix: true, allow_nil: true
  delegate :quantity, to: :sku, prefix: true, allow_nil: true

  # callbacks
  before_save :update_stock
  before_destroy :remove_stock

  # methods
  def subtotal
    quantity * unit_price
  end

  def update_stock
    if self.quantity_changed?
      # se edito/creo el registro
      delta = quantity - quantity_was.to_i
      sku.update_column(:quantity, resourceable.is_a?(Purchase) ? sku_quantity + delta : sku_quantity - delta)
    end
  end

  def remove_stock
    sku.update_column(:quantity, resourceable.is_a?(Purchase) ? sku_quantity - quantity : stock.quantity + quantity )
  end
end
