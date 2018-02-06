class Note < ActiveRecord::Base
  validates_presence_of :description, :message => "Please add some note"
  belongs_to :appointment
  belongs_to :user


  before_create do
  	# binding.pry
    self.user_id = appointment.patient_id if user.role == "patient"
    self.user_id = appointment.doctor_id if user.role == "doctor"
  end

end
