class MessagesController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      MessageMailer.send_message_notification_email(@message).deliver_now
      flash[:notice] = "Message Sent"
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error with the message, please try again"
      render :new
    end
  end


  private
    def message_params
      params.require(:message).permit(:body, :response_type, :response_email, :response_phone, :response_name)
    end
end
