class AddAppointmentReferenceToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :appointment, index: true, foreign_key: true
  end
end
