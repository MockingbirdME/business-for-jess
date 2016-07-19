class AddTotalNumberOfAnimalsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :total_number_of_animals, :integer
  end
end
