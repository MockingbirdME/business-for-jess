require 'rails_helper'


RSpec.describe AppointmentsController, type: :controller do

  let(:my_user){User.create!(name:"howard", email:"howard@walowitz.bbt",phone:"555-555-5555", password:"rappecep")}
  let(:my_owner){User.create!(name:"owner", email:"howard@walowitz.tbbt",phone:"555-555-5555", password:"rappecep", role: 1)}
  let(:my_app){Appointment.create!(user_id: my_user.id, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3)}

  context "guest" do
    describe "GET #new" do
      it "redirects user to log in screen" do
        get :new, user_id: my_user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "POST book appointment" do
      it "redirects users to log in screen" do
        post :book_appointment, user_id: my_user.id, book_appointment:{id: 5, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, user_id: my_user.id, id: my_app.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context "logged in user" do
    before :each do
      sign_in my_user
    end
    describe "GET #new" do
      it "returns http success" do
        get :new, user_id: my_user.id
        expect(response).to have_http_status(:success)
      end
      it "renders the new view" do
        get :new, user_id: my_user.id
        expect(response).to render_template :new
      end
      it "instantiates appointment" do
        get :new, user_id: my_user.id
        expect(assigns(:appointment)).not_to be_nil
      end
    end
    describe "book appointment" do
      it "increases the number of appointments by one" do
        expect {post :book_appointment, user_id: my_user.id, book_appointment:{id: 3, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}}.to change(Appointment, :count).by(1)
      end
      it "assigns the new appointment to @appointments" do
        post :book_appointment, user_id: my_user.id, book_appointment: {id: 2, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}
        expect(assigns(:appointment)).to eq Appointment.last
      end
      it "redirects to the user view" do
        post :book_appointment, user_id: my_user.id, book_appointment: {id: 4, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}
        expect(response).to redirect_to my_user
      end
    end
    describe "DELETE destroy" do
      it "deletes the appointment" do
        delete :destroy, user_id: my_user.id, id: my_app.id, owner: my_owner
        count = Appointment.where({id: my_app.id}).size
        expect(count).to eq 0
      end
      it "redirects to user view" do
        delete :destroy, user_id: my_user.id, id: my_app.id, owner: my_owner
        expect(response).to redirect_to my_user
      end
    end
  end

end
