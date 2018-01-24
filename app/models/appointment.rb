class Appointment < ActiveRecord::Base

  enum status: [:pending, :completed, :cancelled]

  belongs_to :patient, class_name: "User", foreign_key: 'patient_id'
  belongs_to :doctor, class_name: "User", foreign_key: 'doctor_id'
  has_many :notes, dependent: :destroy
  has_many :images, as: :imagable, dependent: :destroy
  # accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true

  def self.closed_status
    self.where('status = ?', 'completed' ).order('created_at DESC')
  end

  def show_my_upcoming_appointments
    if current_user.doctor?
      current_user.patient_appointments.future
    else
      current_user.doctor_appointments.future
    end
  end

  def show_my_previous_appointments
    if current_user.doctor?
      current_user.patient_appointments.past
    else
      current_user.doctor_appointments.past
    end
  end

end
