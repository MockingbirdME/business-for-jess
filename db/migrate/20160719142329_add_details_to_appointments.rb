class AddDetailsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :details, :string
  end
end
