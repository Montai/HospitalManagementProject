class Note < ActiveRecord::Base
	
  validates_presence_of :description, :message => "Please add some note"

  belongs_to :appointment
  belongs_to :user


  before_create do
    self.user_id = appointment.patient_id 
  end

end
