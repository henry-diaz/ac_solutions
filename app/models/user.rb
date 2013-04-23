class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :validatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :role

  # constants
  ROLES = { 'admin' => I18n.t("labels.admin"), 'operator' => I18n.t("labels.operator") }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # relations
  has_and_belongs_to_many :appointments

  # validaciones
  validates :first_name, presence: true, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :role, presence: true, inclusion: { in: ROLES.keys }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: I18n.t("labels.please_enter_a_valid_mail") }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { within: 6..40 }, on: :create
  validates :password, confirmation: true, length: { within: 6..40 }, allow_blank: true, on: :update

  def full_name
    [first_name, last_name].join(" ")
  end

  def role?(base_role)
    role.downcase == base_role.to_s.downcase
  end

  def get_role
    ROLES[role] || ""
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
end
