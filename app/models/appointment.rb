class Appointment < ActiveRecord::Base

  enum status: [:pending, :completed, :cancelled]

  belongs_to :patient, class_name: "User", foreign_key: 'patient_id'
  belongs_to :doctor, class_name: "User", foreign_key: 'doctor_id'
  has_many :notes, dependent: :destroy
  has_many :images, as: :imagable, dependent: :destroy
  # accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true

  validates :date, presence: true
  validate :validate_appointment_date


  def validate_appointment_date
    self.errors.add(:date, 'can not be left as blank') and return if self.date.blank?
    self.errors.add(:date, "please add appointment after 1 hour") and return if self.date < Time.now + 1.hour
  end

  class << self
    def closed_status
      self.where('status = ?', 'completed' ).order('created_at DESC')
    end
  end

end
