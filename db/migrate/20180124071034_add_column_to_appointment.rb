class AddColumnToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :status, :integer, default: 0
  end
end
