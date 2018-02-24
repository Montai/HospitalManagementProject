class AddColumnToAppointmentone < ActiveRecord::Migration
  def change
    add_column :appointments, :slot_tag, :string
  end
end
