class Customer < ActiveRecord::Base
  attr_accessible :code, :phone, :name, :contact, :address, :kind, :description, :email

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }
  KIND = { 'company' => I18n.t("labels.company"), 'natural' => I18n.t("labels.natural_person") }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # relations
  has_many :sales, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy

  # validations
  validates :name, :kind, :phone, :address, presence: true
  validates :name, :phone, length: { maximum: 200 }
  validates :kind, inclusion: { in: KIND.keys }
  validates :code, uniqueness: true, presence: true, length: { within: 4 .. 20 }
  validates :email, format: { with: VALID_EMAIL_REGEX, message: I18n.t("labels.please_enter_a_valid_mail") }, allow_blank: true

  # ransacker
  ransacker :info do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||', parent.table[:code], ' '),
      parent.table[:name])
  end

  # scopes
  scope :active, where(active: ACTIVE)

  # methods
  def status
    STATUS[active] || ""
  end

  def get_kind
    KIND[kind] || ""
  end

  def info
    [code,name].join(" ")
  end
end
