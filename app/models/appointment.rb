class Appointment < ActiveRecord::Base
  attr_accessible :name, :description, :address, :start_at, :end_at, :come

  # relations
  belongs_to :user
  belongs_to :customer
  has_and_belongs_to_many :users
end
