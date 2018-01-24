class RemoveColumnFromAppointment < ActiveRecord::Migration
  def change
    remove_column :appointments, :status
  end
end
