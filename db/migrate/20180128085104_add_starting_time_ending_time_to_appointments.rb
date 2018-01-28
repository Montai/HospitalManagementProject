class AddStartingTimeEndingTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :starting_time, :time
    add_column :appointments, :ending_time, :time
  end
end
