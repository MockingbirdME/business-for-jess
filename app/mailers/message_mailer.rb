class MessageMailer < ApplicationMailer
  default from: 'devon.henegar@gmail.com'

  def send_message_notification_email(message)
    @message = message
    @owner = User.find_by(role: 1)
    mail(to: @owner.email, subject: "New Message Received")
  end
end
