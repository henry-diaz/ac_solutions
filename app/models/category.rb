class Category < ActiveRecord::Base
  attr_accessible :name, :description

  # relations
  has_many :skus, dependent: :destroy
end
