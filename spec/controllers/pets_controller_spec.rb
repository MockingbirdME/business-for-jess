require 'rails_helper'

RSpec.describe PetsController, type: :controller do

  let(:my_user){User.create!(name:"guy",email:"guy@falks.com",phone:"555-555-5555", password:"rappecep")}
  let(:other_user){User.create!(name:"other guy",email:"otherguy@falks.com",phone:"555-555-5555", password:"rappecep")}
  let(:my_pet){Pet.create!(name:"a pet", quantity:0, user_id: my_user.id, description:"a description")}

  context "guest doing CRUD on pets" do
    describe "GET new" do
      it "returns http redirect" do
        get :new, {user_id: my_user.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    describe "POST create" do
      it "returns http redirect" do
        post :create, {user_id: my_user.id, id: my_pet.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    describe "GET edit" do
      it "returns http redirect" do
        get :edit, {user_id: my_user.id, id: my_pet.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT update" do
      it "returns http redirect" do
        new_name = "a different name"
        new_des = "a different description"
        put :update, user_id: my_user.id, id: my_pet.id, pet: {name: new_name, description: new_des}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "a member doing crud on pets they don't own" do
    before do
      sign_in(other_user)
    end

  end

  context "a user doing CRUD on their pet" do
    before do
      sign_in(my_user)
    end
    describe "GET new" do
      it "returns http success" do
        get :new, user_id: my_user.id
        expect(response).to have_http_status(:success)
      end
      it "renders the new view" do
        get :new, user_id: my_user.id
        expect(response).to render_template :new
      end
      it "instantiates @pet" do
        get :new, user_id: my_user.id
        expect(assigns(:pet)).not_to be_nil
      end
    end
    describe "POST create" do
     it "increases the number of Pet by 1" do
       expect{ post :create, user_id: my_user.id, pet: {name:"a new pet", quantity:1, user_id: my_user.id, description:"a cool description"} }.to change(Pet,:count).by(1)
     end

     it "assigns the new pet to @pet" do
       post :create, user_id: my_user.id, pet: {name:"a new pet", quantity:1, user_id: my_user.id, description:"a cool description"}
       expect(assigns(:pet)).to eq Pet.last
     end

     it "redirects to the user" do
       post :create, user_id: my_user.id, pet: {name:"a new pet", quantity:1, user_id: my_user.id, description:"a cool description"}
       expect(response).to redirect_to [my_user]
     end
   end

   describe "GET edit" do
     it "returns http success" do
       get :edit, user_id: my_user.id, id: my_pet.id
       expect(response).to have_http_status(:success)
     end

     it "renders the #edit view" do
       get :edit, user_id: my_user.id, id: my_pet.id
       expect(response).to render_template :edit
     end

     it "assigns post to be updated to @pet" do
       get :edit, user_id: my_user.id, id: my_pet.id
       pet_instance = assigns(:pet)

       expect(pet_instance.id).to eq my_pet.id
       expect(pet_instance.name).to eq my_pet.name
       expect(pet_instance.description).to eq my_pet.description
     end
   end

   describe "PUT update" do
     it "updates post with expected attributes" do
       new_name = "the best name ever"
       new_des = "Awesome description here"

       put :update, user_id: my_user.id, id: my_pet.id, pet: {name: new_name, description: new_des}

       updated_pet = assigns(:pet)
       expect(updated_pet.id).to eq my_pet.id
       expect(updated_pet.name).to eq new_name
       expect(updated_pet.description).to eq new_des
     end

     it "redirects to the user" do
       new_name = "the best name ever"
       new_des = "Awesome description here"

       put :update, user_id: my_user.id, id: my_pet.id, pet: {ame: new_name, description: new_des}
       expect(response).to redirect_to [my_user]
     end
   end
  end

end
