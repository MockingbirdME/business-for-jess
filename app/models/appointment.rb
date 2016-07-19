class Appointment < ActiveRecord::Base

  belongs_to :user
  has_many :pets

  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care]

end
