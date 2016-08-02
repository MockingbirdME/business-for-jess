class Appointment < ActiveRecord::Base
  require 'date'

  belongs_to :user


  enum appointment_type: [:dog_walking, :small_animal_hotel, :in_home_animal_care, :afternoon_off, :day_off]

  after_initialize(:set_total_number_of_animals, {if: :new_record?})

  def set_total_number_of_animals
    self.total_number_of_animals ||= 0
  end

  def self.time_slots(day)

    apps = Appointment.where(start_time: day.to_datetime..((day.to_datetime)+(1.day)))
    apps = apps.where(appointment_type: 0).order(:start_time)
    first = day.midnight+(16.hours)
    last = day.midnight+(19.hours)
    openings = []
    if Appointment.closed_for_the_day?(day) || Appointment.closed_for_the_afternoon?(day)
      return openings
    end
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
    return false if Appointment.closed_for_the_day?(day)
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
    return false if Appointment.closed_for_the_day?(day)
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

  def self.closed_for_the_afternoon?(day)
    closures = Appointment.where(appointment_type: 3)
    closures = closures.where(start_time: day.midnight-(14.days)..day.midnight+(23.hours))
    closures.each do |app|
      if (app.start_time.to_date == day.to_date) || (app.start_time.to_date + ((app.duration-1).days)) > day.to_date
        return true
      end
    end
    return false
  end

  def self.closed_for_the_day?(day)
    closures = Appointment.where(appointment_type: 4)
    closures = closures.where(start_time: (day.midnight-(14.days))..(day.midnight+(23.hours)))
    closures.each do |app|
      if (app.start_time.to_date == day.to_date) || (app.start_time.to_date + ((app.duration-1).days)) > day.to_date
        return true
      end
    end
    return false
  end

  def self.dog_walking_display_for_owner(day)
    apps = Appointment.where(appointment_type: 0)
    apps = apps.where(start_time: day.midnight..(day.midnight+(1.day)))
  end

  def self.hotel_checkins(day)
    apps = Appointment.where(appointment_type: 1)
    apps = apps.where(start_time: day.midnight..(day.midnight+(23.hours)))
  end

  def self.hotel_guests(day)
    potential = Appointment.where(appointment_type: 1)
    apps = []
    potential = potential.where(start_time: (day.midnight-(14.days))..(day.midnight))
    potential.each do |n|
      if (n.start_time.to_date + n.duration.days) > day.to_date
        apps << n
      end
    end
    apps
  end

  def self.care_apps(day)
    potential = Appointment.where(appointment_type: 2)
    apps = []
    potential = potential.where(start_time: (day.midnight-(14.days))..(day.midnight))
    potential.each do |n|
      if (n.start_time.to_date + n.duration.days) > day.to_date
        apps << n
      end
    end
    apps
  end

  def validate_appointment
    returned = []
    if (self.appointment_type == 'dog_walking')||(self.appointment_type == 'small_animal_hotel')||(self.appointment_type == 'in_home_animal_care')
    returned << "Appointment requires a start time" if self.start_time.blank?
    returned << "Appointment date can not be booked in the past" if (self.start_time < Date.current)
    returned << "To ensure our promptness please book your appointments for today by phone, we can be reached at (555-555-5555)" if (self.start_time.to_date == Date.current )
    returned << "We are not accepting appointments with a start date more than two weeks out at this time, please feel free to reach out to us by phone if you need to schedule an appointment that far out (555-555-5555)" if self.start_time.to_date > (Date.current+(15.days))
    end
    if (self.appointment_type == 'afternoon_off')||(self.appointment_type == 'day_off')
      returned << "A start time is needed for your time off" if self.start_time.blank?
      returned << "Time off can not be taken in the past" if (self.start_time < Date.current)
    end
    returned
  end

  def dog_walking_conflict?(potential_time,potential_duration)
    if Appointment.closed_for_the_day?(potential_time) || Appointment.closed_for_the_afternoon?(potential_time)
      return true
    end
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

  def afternoon_off_conflict?(potential_time, potential_duration)
      appointments_to_check = Appointment.where(appointment_type: 'dog_walking').select("start_time")
      appointments_conflicts = appointments_to_check.where(start_time: (potential_time.midnight)..(potential_time.midnight+(potential_duration.days)))
      appointments_conflicts.empty? ? false : true
  end

  def day_off_conflict?(potential_time, potential_duration)
    appointments_to_check = Appointment.where(start_time: (potential_time.to_date.midnight-(14.days))..(potential_time.to_date.midnight+(potential_duration.days)))
    return false if appointments_to_check.empty?
    dog_walking_to_check = Appointment.where(start_time: (potential_time.to_date.midnight)..(potential_time.to_date.midnight+(potential_duration.days))+(23.hours))
    dog_walking_to_check = dog_walking_to_check.where(appointment_type: 0)
    return true if (dog_walking_to_check.count > 0)
    others_to_check = appointments_to_check.where(appointment_type: 1) + appointments_to_check.where(appointment_type: 2)
    others_to_check.any? do |ap|
      within_appointment = (ap.start_time < potential_time)
      within_appointment &&= ((ap.start_time + ap.duration.days) > potential_time)
      during_appointment = (ap.start_time > potential_time)
      during_appointment &&= (ap.start_time < (potential_time+(potential_duration.days)))
      within_appointment || during_appointment
    end
  end

  def conflict?(potential_time, potential_duration)
    case appointment_type
    when 'dog_walking'
      dog_walking_conflict?(potential_time, potential_duration)
    when 'small_animal_hotel'
      small_animal_hotel_conflict?(potential_time, potential_duration)
    when 'in_home_animal_care'
      in_home_animal_care_conflict?(potential_time, potential_duration)
    when 'afternoon_off'
      afternoon_off_conflict?(potential_time, potential_duration)
    when 'day_off'
      day_off_conflict?(potential_time, potential_duration)
    end
  end


end
