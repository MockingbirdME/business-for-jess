require 'rails_helper'


RSpec.describe AppointmentsController, type: :controller do

  let(:my_user){User.create!(name:"howard", email:"howard@walowitz.bbt",phone:"555-555-5555", password:"rappecep")}
  let(:my_owner){User.create!(name:"owner", email:"howard@walowitz.tbbt",phone:"555-555-5555", password:"rappecep", role: 1)}
  let(:my_app){Appointment.create!(user_id: my_user.id, start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3)}
  let(:non_conflicting_appointment){Appointment.create!(user_id: my_user.id, start_time: ((DateTime.current+1.day)+2.hours), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3)}

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
      it "returns http success" do
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
    context "book appointment" do
      let(:conflicting_appointment){post :book_appointment, user_id: my_user.id, appointment:{start_time: ((DateTime.current+1.day)+20.minutes), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}}
      let(:conflicting_appointment_day_off){post :book_appointment, user_id: my_user.id, appointment:{start_time: (DateTime.current+1.day), duration: 7, appointment_type: 'day_off'}}
      let(:conflicting_hotel_1){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+2), duration: 2, appointment_type: 'small_animal_hotel', total_number_of_animals: 3}}
      let(:conflicting_hotel_2){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+2), duration: 2, appointment_type: 'small_animal_hotel', total_number_of_animals: 3}}
      let(:conflicting_hotel_3){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+2), duration: 2, appointment_type: 'small_animal_hotel', total_number_of_animals: 3}}
      let(:conflicting_hotel_for_day_off_2){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+12.days), duration: 4, appointment_type: 'small_animal_hotel', total_number_of_animals: 3}}

      let(:book_it_hotel){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+2), duration: 2, appointment_type: 'small_animal_hotel', total_number_of_animals: 3}}
      let(:book_it_in_home){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+2), duration: 3, appointment_type: 'in_home_animal_care', total_number_of_animals: 3}}
      let(:book_it_afternoon_off){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+1.day), duration: 3, appointment_type: 'afternoon_off', total_number_of_animals: 3}}
      let(:book_it_day_off){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current), duration: 3, appointment_type: 'day_off', total_number_of_animals: 3}}
      let(:book_it_day_off_2){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+13.days), duration: 3, appointment_type: 'day_off', total_number_of_animals: 3}}
      let(:book_it){post :book_appointment, user_id: my_user.id, appointment:{ start_time: (DateTime.current+1.day), duration: 30, appointment_type: 'dog_walking', total_number_of_animals: 3}}
      before :each do
        my_owner
      end
      it "increases the number of appointments by one" do
        expect {book_it}.to change(Appointment, :count).by(1)
      end
      it "assigns the new appointment to @appointments" do
        book_it
        expect(assigns(:appointment)).to eq Appointment.last
      end
      it "redirects to the user view" do
        book_it
        expect(response).to redirect_to my_user
      end
      it "doesn't book conflicting appointments" do
        conflicting_appointment
        conflicting_appointment_day_off
        conflicting_hotel_1
        conflicting_hotel_2
        conflicting_hotel_3
        conflicting_hotel_for_day_off_2
        expect {book_it}.to change(Appointment, :count).by(0)
        expect {book_it_hotel}.to change(Appointment, :count).by(0)
        expect {book_it_in_home}.to change(Appointment, :count).by(0)
        expect {book_it_afternoon_off}.to change(Appointment, :count).by(0)
        expect {book_it_day_off}.to change(Appointment, :count).by(0)
        expect {book_it_day_off_2}.to change(Appointment, :count).by(0)

      end
    end
    describe "DELETE destroy" do
      it "deletes the appointment" do
        delete :destroy, format: :js, user_id: my_user.id, id: my_app.id, owner: my_owner
        count = Appointment.where({id: my_app.id}).size
        expect(count).to eq 0
      end
      it "returns http success" do
        delete :destroy, format: :js, user_id: my_user.id, id: my_app.id, owner: my_owner
        expect(response).to have_http_status(:success)
      end
    end
  end

end
