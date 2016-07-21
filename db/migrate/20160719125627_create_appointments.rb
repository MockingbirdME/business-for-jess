class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :start_time
      t.integer :duration
      t.integer :appointment_type
      t.integer :total_number_of_animals
      t.string :details
      
      t.timestamps null: false
    end
  end
end
