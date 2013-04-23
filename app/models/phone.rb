class Phone < ActiveRecord::Base
  attr_accessible :number

  # validations
  validates :number, presence: true, length: { maximum: 30 }

  # relations
  belongs_to :phoneable, polymorphic: true
end
