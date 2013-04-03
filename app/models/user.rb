class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :registerable, :validatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  def full_name
    [first_name, last_name].join(" ")
  end
end
