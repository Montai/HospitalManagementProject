class AddSlotIdToAppointment < ActiveRecord::Migration
  def change
  	add_column :appointments, :slot_id, :integer
  end
end
