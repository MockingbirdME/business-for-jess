class Appointment < ActiveRecord::Base
  require 'date'

  belongs_to :user
  has_many :pets


  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care]


  def self.time_slots(day)
    apps = Appointment.where(start_time: day.to_datetime..((day.to_datetime)+(1.day)))
    apps = apps.order(:start_time)
    first = day.midnight+(12.hours)
    last = day.midnight+(20.hours)
    openings = []
    unless apps.empty?
      if apps.first.start_time > (day.midnight+(12.hours)+(45.minutes))
        openings << [first, (apps.first.start_time-(15.minutes))]
      end
      if apps.count > 1
        ((apps.count)-1).times do |n|
          if ((apps[n].start_time)+((apps[n].duration+60).minutes)) <= apps[n+1].start_time
            openings << [((apps[n].start_time)+((apps[n].duration+15).minutes)), (apps[n+1].start_time-(15.minutes))]
          end
        end
      end
      if (apps.last.start_time + (apps.last.duration + 45).minutes) <= last
        openings << [apps.last.start_time+((apps.last.duration+15).minutes),last]
      end
    end
    openings
  end


  def validate_appointment
    returned = []
    returned << "Appointment requires a start time" if self.start_time.blank?
    returned << "Appointment date can not be in the past" if (self.start_time < Time.current)
    returned << "Please book by phone for appointments within the next two hours, we can be reached at (207)-555-5555" if ((self.start_time >= Time.current)&&(self.start_time < Time.current + 2.hours))
    returned
  end


  def dog_walking_conflict?(potential_time,potential_duration)
    earliest_potential_conflict = potential_time-(135.minutes)
    end_of_potential_apt= potential_time+((potential_duration+15).minutes)
    appointments_to_check = Appointment.where(start_time: earliest_potential_conflict..end_of_potential_apt).select("start_time, duration")
    if appointments_to_check.empty?
      return false
    else
      appointments_to_check.any? do |app|
        within_appointment = (app.start_time < potential_time)
        within_appointment &&=  (app.start_time + ((app.duration+15).minutes) <= potential_time)
        during_appointment = (app.start_time > potential_time)
        during_appointment &&= (app.start_time > potential_time+((potential_duration+15).minutes))
        within_appointment || during_appointment
      end
    end
  end
end
