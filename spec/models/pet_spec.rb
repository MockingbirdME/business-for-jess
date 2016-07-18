require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:my_user){User.create!(name:"guy",email:"guy@falks.com",phone:"555-555-5555", password:"rappecep")}
  let(:my_pet){Pet.create!(name:"a pet", quantity:0, user_id: my_user.id, description:"a description")}
  it {is_expected.to belong_to(:user)}

  describe "attributes" do
    it "should have name, email, phone attributes" do
      expect(my_pet).to have_attributes(name: my_pet.name, user_id: my_pet.user_id, quantity: my_pet.quantity, description: my_pet.description)
    end
    it "responds to animal type" do
      expect(my_pet).to respond_to(:animal_type)
      expect(my_pet).to respond_to(:dog?)
      expect(my_pet).to respond_to(:cat?)
      expect(my_pet).to respond_to(:small_animals?)
    end
    it "is a dog by default" do
      expect(my_pet.animal_type).to eq("dog")
    end
  end


end
