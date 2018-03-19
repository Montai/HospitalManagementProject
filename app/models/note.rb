class Note < ActiveRecord::Base
  #Model Associations
  belongs_to :appointment
  belongs_to :user
  #Model Validations
  validates :description, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/i, message: "can only contain letters and numbers." }
end
