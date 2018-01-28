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

    def check_appointment_collision(appointments, current_appointment)
      appointments.each do |appointment|
        if current_appointment.doctor.first_name == appointment.doctor.first_name &&
          current_appointment.patient.first_name == appointment.patient.first_name &&
          current_appointment.date.strftime("%B %d, %Y") == appointment.date.strftime("%B %d, %Y")

          return false

        elsif current_appointment.doctor.first_name == appointment.doctor.first_name &&
           current_appointment.patient.first_name != appointment.patient.first_name &&
           current_appointment.date.strftime("%B %d, %Y") == appointment.date.strftime("%B %d, %Y") &&
           (current_appointment.starting_time.to_s(:time) >= appointment.starting_time.to_s(:time) && current_appointment.starting_time.to_s(:time) >= appointment.ending_time.to_s(:time))

           return false

         end
      end

        return true
    end

  end

end
