class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :zxcvbnable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  has_many :pets
  has_many :appointments
end
