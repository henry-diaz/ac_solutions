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
  delegate :kind, to: :itemable, prefix: :item, allow_nil: true

  # callbacks
  before_save :update_stock
  before_destroy :remove_stock

  # scope
  scope :by_type, lambda { |type| joins("JOIN #{type.table_name} ON #{type.table_name}.id = #{Item.table_name}.resourceable_id AND #{Item.table_name}.resourceable_type = '#{type.to_s}'") }

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

  def self.sales_by_filters options
    scope = scoped
    scope = scope.where(:sales => { :customer_id => options[:customer_id_in] }) if options[:customer_id_in]
    scope = scope.where(:sales => { :sale_date => options[:sale_date_gteq] .. options[:sale_date_lteq] }) if options[:sale_date_lteq] and options[:sale_date_gteq]
    if options[:sku_id_in] and options[:service_id_in]
      scope = scope.where("(items.itemable_id in (:sku_ids) and items.itemable_type = 'Sku') or (items.itemable_id in (:service_ids) and items.itemable_type = 'Service')", sku_ids: options[:sku_id_in], service_ids: options[:service_id_in])
    elsif options[:sku_id_in]
      scope = scope.where("(items.itemable_id in (:sku_ids) and items.itemable_type = 'Sku') or items.itemable_type = 'Service'", sku_ids: options[:sku_id_in])
    elsif options[:service_id_in]
      scope = scope.where("(items.itemable_id in (:service_ids) and items.itemable_type = 'Service') or items.itemable_type = 'Sku'", service_ids: options[:service_id_in])
    end
    if options[:klass_in].include?('Sku') and options[:klass_in].include?('Service')
      # do nothing
    elsif options[:klass_in].include?('Sku')
      scope = scope.where(:itemable_type => "Sku")
    elsif  options[:klass_in].include?('Service')
      scope = scope.where(:itemable_type => "Service")
    end
    if options[:kind_in].include?('bill') and options[:kind_in].include?('fiscal')
      # do nothing
    elsif options[:kind_in].include?('bill')
      scope = scope.where(:sales => { :kind => "bill" })
    elsif  options[:kind_in].include?('fiscal')
      scope = scope.where(:sales => { :kind => "fiscal" })
    end
    scope
  end

  def self.purchases_by_filters options
    scope = scoped
    scope = scope.where(:purchases => { :purchase_date => options[:purchase_date_gteq] .. options[:purchase_date_lteq] }) if options[:purchase_date_lteq] and options[:purchase_date_gteq]
    scope = scope.where(:itemable_id => options[:sku_id_in]) if options[:sku_id_in]
    if options[:kind_in].include?('bill') and options[:kind_in].include?('fiscal')
      # do nothing
    elsif options[:kind_in].include?('bill')
      scope = scope.where(:purchases => { :kind => "bill" })
    elsif  options[:kind_in].include?('fiscal')
      scope = scope.where(:purchases => { :kind => "fiscal" })
    end
    scope
  end
end
