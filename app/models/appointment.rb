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
  belongs_to :time_slot, foreign_key: 'slot_id'
  #Model Validations
  validates :date, presence: true
  validates :doctor_id, presence: true
  validates :slot_id, presence: true
  validates :image,
            presence: true,
            format: { with: %r{\.(gif|jpg|png)\z}i, message: "" }
  validate :image_size_validation
  # validate :validate_appointment_date
  accepts_nested_attributes_for :notes, allow_destroy: true

  def self.get_current_status(date)
    return Appointment.statuses[:pending] if date > Time.now
    return Appointment.statuses[:unvisited]
  end

  private
    #Custom Validation on image size
    def image_size_validation
      errors[:image] << "should be less than 3MB" if image.size > 3.megabytes
    end

    def validate_appointment_date
      errors[:date] << "Can't Book past appointment" if date < Time.now
    end
end
