class AddColumnsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :doctor_id, :integer
    add_column :appointments, :patient_id, :integer
    add_column :appointments, :date, :datetime
    add_column :appointments, :status, :string
  end
end
