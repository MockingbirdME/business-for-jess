class AppointmentMailer < ApplicationMailer
  default from: 'devon.henegar@gmail.com'

  def send_confirmation_email(appointment)
    @appointment = appointment
    @user = @appointment.user
    mail(to: @appointment.user.email, subject: "Appointment Confirmation")
  end

  def email_new_app_to_owner(appointment)
    @appointment = appointment
    @owner = User.find_by(role: 1)
    mail(to: @owner.email, subject: "new booking!")
  end
  def email_canceled_app_to_owner(appointment)
    @appointment = appointment
    @owner = User.find_by(role: 1)
    mail(to: @owner.email, subject: "canceled booking!")
  end
end
