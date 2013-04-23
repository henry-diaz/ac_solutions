class Customer < ActiveRecord::Base
  attr_accessible :code, :phone, :name, :contact, :address, :kind, :description

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }
  KIND = { 'company' => I18n.t("labels.company"), 'natural' => I18n.t("labels.natural_person") }

  # relations
  has_many :sales, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy

  # validations
  validates :name, :kind, :phone, :address, presence: true
  validates :name, :phone, length: { maximum: 200 }
  validates :kind, inclusion: { in: KIND.keys }
  validates :code, uniqueness: true

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

  def get_kind
    KIND[kind] || ""
  end

  def info
    [code,name].join(" ")
  end
end
