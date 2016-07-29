class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @appointment = Appointment.new
  end
end
