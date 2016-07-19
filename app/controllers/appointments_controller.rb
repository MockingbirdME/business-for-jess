class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.all
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @appointment = Appointment.new
  end

  def create
    @user = User.find(params[:user_id])
    @appointment = @user.appointments.build(appointment_params)

    if @appointment.save
      flash[:notice] = "Appointment has been added to the calendar"
      redirect_to @user
    else
      flash.now[:alert] = "There was an error, please try again"
      render :new
    end
  end

  def edit
  end

  private
    def appointment_params
      params.require(:appointment).permit(:appointment_type, :total_number_of_animals, :details)
    end
end
