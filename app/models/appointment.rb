class ValidDateValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if value < Time.now
      object.errors[attribute] << (options[:message] || "Ingrese una fecha/hora mayor que la actual")
    end
  end
end

class Appointment < ActiveRecord::Base
  attr_accessible :name, :description, :address, :start_at, :end_at, :come, :customer_id, :user_ids

  # relations
  belongs_to :user
  belongs_to :customer
  has_and_belongs_to_many :users

  # validations
  validates :start_at, valid_date: true
  validates :customer_id, presence: true

  # delegates
  delegate :name, to: :customer, allow_nil: true, prefix: true

  # methods
  def title
    "#{start_at.try(:strftime, "%H:%M")} #{name.blank? ? description : name}"
  end

  def self.by_user user
    if user.role?(:admin)
      scoped
    else
      joins(:users).where("appointments.user_id = :user_id or users.id = :user_id", user_id: user.id).uniq
    end
  end

  def self.by_date date = Date.today
    where(start_at: date.beginning_of_month .. date.end_of_month + 1.day)
  end
end
