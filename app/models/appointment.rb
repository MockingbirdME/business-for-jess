class Appointment < ActiveRecord::Base
  require 'date'

  belongs_to :user


  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care]

  def self.time_slots(day)
    apps = Appointment.where(start_time: day.to_datetime..((day.to_datetime)+(1.day)))
    apps = apps.where(appointment_type: 0).order(:start_time)
    first = day.midnight+(16.hours)
    last = day.midnight+(19.hours)
    openings = []
    if apps.empty?
      openings << [first,last]
    else
      if apps.first.start_time >= (day.midnight+(16.hours)+(45.minutes))
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

  def self.hotel_vacancy?(day)
    guests = Appointment.where(appointment_type: 1)
    guests = guests.where(start_time: ((day.to_datetime.midnight)-(13.days))..day.to_datetime.midnight)
    guests_for_night = 0
    unless guests.empty?
      guests.each do |app|
        if app.start_time.to_date ==  day.to_date || ((app.start_time.to_date+app.duration.days)>day)
          guests_for_night += 1
        end
      end
    end
    guests_for_night >= 3 ? false : true
  end

  def self.in_home_time?(day)
    apps = Appointment.where(appointment_type: 1)
    apps = apps.where(start_time: ((day.to_datetime.midnight)-(13.days))..day.to_datetime.midnight)
    homes_for_the_day = 0
    unless apps.empty?
      apps.each do |app|
        if app.start_time.to_date ==  day.to_date || ((app.start_time.to_date+app.duration.days)>day)
          homes_for_the_day += 1
        end
      end
    end
    if day.to_date.saturday? || day.to_date.sunday?
      homes_for_the_day >= 3 ? false : true
    else
      homes_for_the_day >+ 1 ? false : true
    end
  end

  def validate_appointment
    returned = []
    returned << "Appointment requires a start time" if self.start_time.blank?
    returned << "Appointment date can not be in the past" if (self.start_time < Date.current)
    returned << "To ensure our promptness please book your appointments for today by phone, we can be reached at (555-555-5555)" if (self.start_time.to_date == Date.current )
    returned
  end

  def dog_walking_conflict?(potential_time,potential_duration)
    earliest_potential_conflict = potential_time-(135.minutes)
    end_of_potential_apt= potential_time+((potential_duration+15).minutes)
    appointments_to_check = Appointment.where(start_time: earliest_potential_conflict..end_of_potential_apt).select("start_time, duration")
    appointments_to_check = appointments_to_check.where(appointment_type: 0)
    if appointments_to_check.empty?
      return false
    else
      appointments_to_check.any? do |app|
        within_appointment = (app.start_time < potential_time)
        within_appointment &&=  (app.start_time + ((app.duration+15).minutes) > potential_time)
        during_appointment = (app.start_time > potential_time)
        during_appointment &&= (app.start_time < potential_time+((potential_duration+15).minutes))
        within_appointment || during_appointment
      end
    end
  end

  def small_animal_hotel_conflict?(potential_time, potential_duration)
    conflicts = []
    potential_duration.times do |n|
      date = potential_time.to_date+(n.days)
      conflicts << date if (Appointment.hotel_vacancy?(date) == false)
    end
    conflicts.empty? ? false : true
  end

  def in_home_animal_care_conflict?(potential_time, potential_duration)
    conflicts = []
    potential_duration.times do |n|
      date = potential_time.to_date+(n.days)
      conflicts << date if (Appointment.in_home_time?(date) == false)
    end
    conflicts.empty? ? false : true
  end

  def conflict?(potential_time, potential_duration)
    case appointment_type
    when 'dog_walking'
      dog_walking_conflict?(potential_time, potential_duration)
    when 'small_animal_hotel'
      small_animal_hotel_conflict?(potential_time, potential_duration)
    when 'in_home_animal_care'
      in_home_animal_care_conflict?(potential_time, potential_duration)
    end
  end


end
