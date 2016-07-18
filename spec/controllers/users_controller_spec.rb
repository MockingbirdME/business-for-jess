require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:my_user){User.create!(name:"howard", email:"howard@walowitz.bbt",phone:"555-555-5555", password:"rappecep")}

  context "sign in user" do
    before do
      sign_in my_user
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, {id: my_user.id}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
