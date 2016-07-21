class Pet < ActiveRecord::Base
  belongs_to :user
  has_many :appointments

  validates :name, presence: true
  validates :animal_type, presence: true
  validates :description, presence: true

  enum animal_type: [:dog, :cat, :small_animals]
  after_initialize(:set_default_animal_type, {if: :new_record?})

  def set_default_animal_type
    self.animal_type ||= :dog
  end
end
