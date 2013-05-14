class Sku < ActiveRecord::Base
  attr_accessible :category_id, :code, :name, :unit_price, :quantity, :active, :kind

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }
  KIND = { 'product' => I18n.t("labels.product"), 'material' => I18n.t("labels.material") }

  # relations
  has_many :items, as: :itemable, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :adjustments, dependent: :destroy
  belongs_to :category, counter_cache: true

  # scope
  scope :active, where(active: ACTIVE)
  scope :with_stock, where("skus.quantity > 0")
  scope :products, where(kind: :product)
  scope :materials, where(kind: :material)

  # validations
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 1000000, only_integer: true }
  validates :name, presence: true, length: { maximum: 200 }
  validates :code, presence: true, uniqueness: { case_sensitive: false }, length: { within: 4 .. 20 }, if: :is_product?
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }, if: :is_product?
  validates :kind, presence: true, inclusion: { in: KIND.keys }

  # callbacks
  after_create :first_adjustment
  before_update :edit_adjustment

  # ransacker
  ransacker :info do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||', parent.table[:code], ' '),
      parent.table[:name])
  end

  # methods
  def status
    STATUS[active] || ""
  end

  def active?
    active == 1
  end

  def first_adjustment
    adjustments.create(adjustment_date: Date.today, user: User.current, quantity: quantity, comment: I18n.t("labels.adjustment_create"))
  end

  def edit_adjustment
    if quantity_changed?
      adjustments.create(adjustment_date: Date.today, user: User.current, quantity: quantity - quantity_was, comment: I18n.t("labels.adjustment_edit"))
    end
  end

  def itemable_id
    self[:id]
  end

  def itemable_type
    self.class.to_s
  end

  def get_kind
    KIND[kind]
  end

  def is_product?
    kind == "product"
  end

  def is_material?
    kind == "material"
  end

  def info
    [code,name].join(" ")
  end

  def self.by_filters options
    scope = scoped
    if options[:quantity_lteq] and options[:quantity_gteq]
      scope = scope.where(:quantity => options[:quantity_gteq] .. options[:quantity_lteq])
    elsif options[:quantity_lteq]
      scope = scope.where("skus.quantity <= ?", options[:quantity_lteq])
    elsif options[:quantity_gteq]
      scope = scope.where("skus.quantity >= ?", options[:quantity_gteq])
    end
    scope = scope.where(:id => options[:id_in]) if options[:id_in]
    if options[:kind_in].include?('product') and options[:kind_in].include?('material')
      # do nothing
    elsif options[:kind_in].include?('product')
      scope = scope.where(:kind => "product" )
    elsif  options[:kind_in].include?('material')
      scope = scope.where(:kind => "material" )
    end
    scope
  end

end
