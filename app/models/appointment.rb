class Appointment < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  enum status: [:pending, :unvisited, :cancelled, :visited]
  #Validations
  validates :date, presence: true
  validates :doctor_id, presence: true
  validates :image,
            presence: true,
            format: { with: %r{\.(gif|jpg|png)\z}i, message: "" }
  #Associations
  belongs_to :patient,
              class_name: "User",
              foreign_key: 'patient_id'
  belongs_to :doctor,
              class_name: "User",
              foreign_key: 'doctor_id'
  has_many :notes, dependent: :destroy
  accepts_nested_attributes_for :notes, allow_destroy: true
end
