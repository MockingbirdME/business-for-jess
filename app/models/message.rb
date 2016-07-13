class Message < ActiveRecord::Base

  enum response_type: [:none_required, :email, :phone, :text]
  after_initialize(:set_default_response_type, {if: :new_record?})

  validates :body, length: {minimum: 10}, presence: true
  validates_presence_of :response_type

  validates_presence_of :response_name, if: :requires_response?
  validates_presence_of :response_email, if: :requires_email?
  validates_presence_of :response_phone, if: :requires_phone?

  def set_default_response_type
    self.response_type ||= :none_required
  end

  def requires_response?
    self.response_type != "none_required"
  end
  def requires_email?
    self.response_type == "email"
  end
  def requires_phone?
    (self.response_type == "phone") || (self.response_type == "text")
  end
end
