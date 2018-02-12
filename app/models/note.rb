class Note < ActiveRecord::Base

  validates_presence_of :description, message: "Please add some note", length: { minimum: 2, maximum: 255 }
  validate :validate_note

  belongs_to :appointment
  belongs_to :user

  def validate_note
  	self.errors.add(:description, 'can not be left as blank') and return if self.description.blank?
  end 


  # before_create do
  #   self.user_id = appointment.patient_id 
  # end

  # after_save do 
  # 	Note.update_attribute(:user_id, :patient_id) if user.role == "patient"
  # 	Note.update_attribute(:user_id, :doctor_id) if user.role == "doctor"
  # end 

end
