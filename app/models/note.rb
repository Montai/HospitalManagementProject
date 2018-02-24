class Note < ActiveRecord::Base
  validates :description, 
            presence: true,  
            format: { with: /\A[a-zA-Z0-9\s]+\z/i, message: "can only contain letters and numbers." }

  belongs_to :appointment
  belongs_to :user
end
