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

  def book_appointment
    @user = User.find(params[:user_id])
    @appointment = @user.appointments.build(appointment_params)
    @validated = @appointment.validate_appointment
    if @validated.empty?
      if @appointment.dog_walking_conflict?(@appointment.start_time, @appointment.duration) == false
        @appointment.save!
        flash[:notice] = "Appointment has been added to the calendar"
        redirect_to @user
      else
        flash.now[:alert] = "There is a schedule conflict with the appointment, please try agian"
        render :new
      end
    else
      @validated.each do |val|
        flash.now[:alert] = val
      end
      render :new
    end
  end

    def destroy
      @user = User.find(params[:user_id])
      @appointment = @user.appointments.find(params[:id])
      if @appointment.destroy
        flash[:notice] = "Appointment successfully canceled"
        redirect_to @user
      else
        flash[:alert] = "there was an error, please try again"
        redirect_to @user
      end
    end

  private
    def appointment_params
      params.require(:appointment).permit(:appointment_type, :total_number_of_animals, :details, :date, :start_time, :duration)
    end
end
