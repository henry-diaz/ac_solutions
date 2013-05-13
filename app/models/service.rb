class Service < ActiveRecord::Base
  attr_accessible :code, :name, :unit_price, :description, :active

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }

  # relations
  has_many :items, as: :itemable, dependent: :destroy

  # scope
  scope :active, where(active: ACTIVE)

  # validations
  validates :name, presence: true, length: { maximum: 200 }
  validates :code, presence: true, uniqueness: { case_sensitive: false }, length: { within: 4 .. 20 }
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }

  # methods
  def status
    STATUS[active] || ""
  end

  def active?
    active == 1
  end

  def itemable_id
    self[:id]
  end

  def itemable_type
    self.class.to_s
  end
end
