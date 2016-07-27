require 'rails_helper'

RSpec.describe MessagesController, type: :controller do


  let(:my_message){Message.create!(body:"new message body", response_name: "some guy", response_email: "some@guy.com", response_phone: "555-555-5555")}
  let(:my_owner){User.create!(name:"owner", email:"howard@walowitz.tbbt",phone:"555-555-5555", password:"rappecep", role: 1)}

  describe "GET index" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_message to @messages"do
      get :index
      expect(assigns(:messages)).to eq([my_message])
    end
  end

  describe "Get new" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders the new view" do
      get :new
      expect(response).to render_template :new
    end
    it "instantiates @message" do
      get :new
      expect(assigns(:message)).not_to be_nil
    end
  end

  describe "Post create" do
    it "increases the number of messages by one" do
      expect{post :create, owener: my_owner, message:{body:"new message body", response_name: "steven king", response_email: "steve@royalty.come", response_phone:"555-555-5555"}}.to change(Message, :count).by(1)
    end
    it "assigns the new message to @message" do
      post :create, owner: my_owner, message:{body:"new message body", response_name: "steven king", response_email: "steve@royalty.come", response_phone:"555-555-5555"}
      expect(assigns(:message)).to eq Message.last
    end
    it "redirects to the home page" do
      post :create, owner: my_owner, message:{body:"new message body", response_name: "steven king", response_email: "steve@royalty.come", response_phone:"555-555-5555"}
      expect(response).to redirect_to root_path
    end
  end


end
