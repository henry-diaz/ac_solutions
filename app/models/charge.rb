class Charge < ActiveRecord::Base
  attr_accessible :name

  # validations
  validates :name, presence: true, length: { maximum: 200 }

  # scopes
  default_scope order("charges.name ASC")
end
