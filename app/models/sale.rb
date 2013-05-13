class Sale < ActiveRecord::Base
  attr_accessible :customer_id, :comment, :sale_date, :kind, :number

  # constants
  KIND = { "bill" => I18n.t("labels.bill"), "fiscal" => I18n.t("labels.fiscal_credit") }

  # relations
  has_many :items, as: :resourceable, dependent: :destroy
  belongs_to :customer

  # validations
  validates :sale_date, presence: true
  validates :number, presence: true, uniqueness: { scope: :kind }, on: :update
  validates :kind, presence: true, inclusion: { in: KIND.keys }

  # delegates
  delegate :name, to: :customer, prefix: true, allow_nil: true
  delegate :code, to: :customer, prefix: true, allow_nil: true

  # methods
  def total
    items.map(&:subtotal).inject(:+) || 0
  end

  def get_kind
    KIND[kind]
  end
end
