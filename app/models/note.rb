class Note < ActiveRecord::Base
  VALID_CONTENT_REGEX = /\A[a-zA-Z0-9\s]+\z/i
  #Model Associations
  belongs_to :appointment
  belongs_to :user
  #Model Validations
  validates :description, presence: true, format: { with: VALID_CONTENT_REGEX, message: "can only contain letters and numbers." }
end
