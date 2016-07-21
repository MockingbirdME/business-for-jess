class Appointment < ActiveRecord::Base
  require 'date'

  belongs_to :user
  has_many :pets


  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care]

  def validate_appointment
    returned = []
    returned << "Appointment requires a start time" if self.start_time.blank?
    returned << "Appointment date can not be in the past" if (self.start_time < Time.current)
    returned << "Please book by phone for appointments within the next two hours, we can be reached at (207)-555-5555" if ((self.start_time >= Time.current)&&(self.start_time < Time.current + 2.hours))
    returned
  end


  def check_for_dog_walking_conflicts(potential_time,potential_duration)
    appointments_to_check = Appointment.where(start_time: (potential_time-(135.minutes))..potential_time+((potential_duration+15).minutes))
    if appointments_to_check.empty?
      return false
    else
      appointments_to_check.each do |app|
        if app.start_time < potential_time
          if app.start_time + ((app.duration+15).minutes) <= potential_time
            return false
          end
        elsif app.start_time > potential_time
          if app.start_time > potential_time+((potential_duration+15).minutes)
            return false
          end
        else
          return true
        end
      end
    end
  end
end
