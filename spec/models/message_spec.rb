require 'rails_helper'

RSpec.describe Message, type: :model do

  let(:my_message){Message.create!(body:"my new message", response_name: "Jody", response_email: "guy@yahoo.com", response_phone: "555-292-1234")}


  it {is_expected.to validate_presence_of (:response_type)}

  describe "attributes" do
    it "should have body and response_type attribute" do
      expect(my_message).to have_attributes(body: my_message.body, response_type: my_message.response_type)
    end
    it "should default to response type none_required" do
      expect(my_message.response_type).to eq("none_required")
    end
  end

  describe "validates for response type" do
    it " checks to see if name is required" do
      expect(my_message).to_not validate_presence_of(:response_name)
      my_message.response_type=1
      expect(my_message).to validate_presence_of(:response_name)
    end
    it " checks to see if name is required" do
      expect(my_message).to_not validate_presence_of(:response_email)
      my_message.response_type=1
      expect(my_message).to validate_presence_of(:response_email)
    end
    it " checks to see if name is required" do
      expect(my_message).to_not validate_presence_of(:response_phone)
      my_message.response_type=2
      expect(my_message).to validate_presence_of(:response_phone)
      my_message.response_type=3
      expect(my_message).to validate_presence_of(:response_phone)
    end
  end

end
