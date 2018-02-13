class Note < ActiveRecord::Base

  validates_presence_of :description, message: "Please add some note", length: { minimum: 2, maximum: 255 }
  validate :validate_note

  belongs_to :appointment
  belongs_to :user

  def validate_note
  	self.errors.add(:description, 'can not be left as blank') and return if self.description.blank?
  end 


end
