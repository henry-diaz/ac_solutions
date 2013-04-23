class Contact < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :charge_id, :phone, :email, :active

  # associations
  belongs_to :contactable, polymorphic: true
  belongs_to :charge
  #has_many :emails, as: :emailable, dependent: :destroy
  #has_many :phones, as: :phoneable, dependent: :destroy
  #accepts_nested_attributes_for :emails, allow_destroy: true
  #accepts_nested_attributes_for :phones, allow_destroy: true

  # delegates
  delegate :name, to: :charge, allow_nil: true, prefix: true

  # constants
  INACTIVE = 0
  ACTIVE = 1
  STATUS = { INACTIVE => I18n.t("labels.inactive"), ACTIVE => I18n.t("labels.active") }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # validates
  validates :first_name, :last_name, presence: true, length: { maximum: 200 }
  validates :email, format: { with: VALID_EMAIL_REGEX, message: I18n.t("labels.please_enter_a_valid_mail") }, allow_blank: true

  # scopes
  default_scope includes(:charge)
  scope :active, where(active: 1)

  # methods
  def status
    STATUS[active] || ""
  end
end
