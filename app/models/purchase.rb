class Purchase < ActiveRecord::Base
  attr_accessible :number, :comment, :purchase_date, :kind

  # constants
  KIND = { "bill" => I18n.t("labels.bill"), "fiscal" => I18n.t("labels.fiscal_credit") }

  # relations
  has_many :items, as: :resourceable, dependent: :destroy

  # validations
  validates :number, presence: true, uniqueness: { scope: :kind }
  validates :purchase_date, presence: true
  validates :kind, presence: true, inclusion: { in: KIND.keys }

  # methods
  def total
    items.map(&:subtotal).inject(:+) || 0
  end

  def get_kind
    KIND[kind]
  end
end
