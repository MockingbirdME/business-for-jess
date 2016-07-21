class Appointment < ActiveRecord::Base
  require 'date'

  belongs_to :user
  has_many :pets


  validates :total_number_of_animals, presence: true
  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care]

end
