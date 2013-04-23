class Sku < ActiveRecord::Base
  attr_accessible :category_id, :code, :name, :unit_price, :quantity, :active

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }

  # relations
  has_many :items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :adjustments, dependent: :destroy
  belongs_to :category, counter_cache: true

  # scope
  scope :active, where(active: ACTIVE)

  # validations
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 1000000, only_integer: true }
  validates :code, :name, presence: true, length: { maximum: 200 }
  validates :code, uniqueness: { case_sensitive: false }, length: { within: 4 .. 20 }
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }

  # callbacks
  before_create :first_adjustment
  before_update :edit_adjustment

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

  def sku_id
    self[:id]
  end

end
