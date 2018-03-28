class RemoveSlotTagFromAppointment < ActiveRecord::Migration
  def change
  	remove_column :appointments, :slot_tag
  end
end
