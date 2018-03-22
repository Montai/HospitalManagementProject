class Appointment < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  enum status: [:pending, :unvisited, :cancelled, :visited]
  #Model Associations
  belongs_to :patient,
              class_name: "User",
              foreign_key: 'patient_id'
  belongs_to :doctor,
              class_name: "User",
              foreign_key: 'doctor_id'
  has_many :notes, dependent: :destroy
  has_many :images, as: :imagable, dependent: :destroy
  #Model Validations
  validates :date, presence: true
  validates :doctor_id, presence: true
  validates :image,
            presence: true,
            format: { with: %r{\.(gif|jpg|png)\z}i, message: "" }
  validate :image_size_validation
  accepts_nested_attributes_for :notes, allow_destroy: true

  private 
    #Custom Validation on image size
    def image_size_validation
      errors[:image] << "should be less than 3MB" if image.size > 3.megabytes
    end 
end
