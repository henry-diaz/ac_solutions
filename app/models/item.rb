class ValidQuantityValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    # is a sale
    if object.resourceable.is_a?(Sale) and object.itemable.is_a?(Sku)
      delta = object.quantity.to_i - object.quantity_was.to_i
      # verify that the items sold not exceed stock
      if delta > object.item_quantity
        object.errors[attribute] << (options[:message] || I18n.t("labels.out_of_sale_range", number: object.item_quantity + object.quantity_was.to_i))
      end
    end
  end
end

class Item < ActiveRecord::Base
  attr_accessible :itemable_id, :itemable_type, :quantity, :unit_price, :resourceable

  # relations
  belongs_to :resourceable, polymorphic: true, counter_cache: true
  belongs_to :itemable, polymorphic: true

  # validations
  validates :itemable_id, :itemable_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 1000000, only_integer: true }, valid_quantity: true
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }

  # delegates
  delegate :code, to: :itemable, prefix: :item, allow_nil: true
  delegate :name, to: :itemable, prefix: :item, allow_nil: true
  delegate :quantity, to: :itemable, prefix: :item, allow_nil: true

  # callbacks
  before_save :update_stock
  before_destroy :remove_stock

  # methods
  def subtotal
    quantity * unit_price
  end

  def update_stock
    if self.quantity_changed? and self.itemable.is_a?(Sku)
      # se edito/creo el registro
      delta = quantity - quantity_was.to_i
      itemable.update_column(:quantity, resourceable.is_a?(Purchase) ? item_quantity + delta : item_quantity - delta)
    end
  end

  def remove_stock
    if self.itemable.is_a?(Sku)
      itemable.update_column(:quantity, resourceable.is_a?(Purchase) ? item_quantity - quantity : item_quantity + quantity )
    end
  end
end
