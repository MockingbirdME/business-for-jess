class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user, index: true, foreign_key: true
      t.date :date
      t.time :start_time
      t.integer :duration

      t.timestamps null: false
    end
  end
end
