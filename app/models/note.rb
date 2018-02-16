class Note < ActiveRecord::Base

  validate :validate_note

  belongs_to :appointment
  belongs_to :user

  def validate_note
  	self.errors.add(:description, 'can not be left as blank') and return if self.description.blank?
  end 

end
