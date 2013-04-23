class Email < ActiveRecord::Base
  attr_accessible :address

  # validations
  validates :address, presence: true, length: { maximum: 200 }

  # relations
  belongs_to :emailable, polymorphic: true
end
