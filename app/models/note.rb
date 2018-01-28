class Note < ActiveRecord::Base
  validates_presence_of :description, :message => "Please enter at least 5 characters"
  belongs_to :appointment
  belongs_to :user

  before_create  do
    self.user_id = appointment.patient_id
    self.user_id = appointment.doctor_id 
  end

end
