class PetsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @pet = Pet.new
  end
  def create
    @user = User.find(params[:user_id])
    @pet = @user.pets.build(pet_params)

    if @pet.save
      flash[:notice] = "Pet(s) were successfully added"
      redirect_to @user
    else
      flash.now[:alert] = "There was an error, please try again"
      render :new
    end
  end
  def edit
    @pet = Pet.find(params[:id])
  end
  def update
    @pet = Pet.find(params[:id])
    @pet.assign_attributes(pet_params)
    if @pet.save
      flash[:notice] = "#{@pet.name} was successfully updated"
      redirect_to @pet.user
    else
      flash.now[:alert] = "There was an error, please try again"
      render :new
    end
  end




  private
    def pet_params
      params.require(:pet).permit(:name, :quantity, :animal_type, :description)
    end

end
