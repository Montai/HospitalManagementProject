class Appointment < ActiveRecord::Base
  # after_update :check_status

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

  # def check_status
  #   if current_user.doctor?
  #     @appointments = current_user.patient_appointments.future
  #   else
  #     @appointments = current_user.doctor_appointments.future
  #   end
  #
  #   @appointments.each do |appointment|
  #     if appointment.date > Time.now
  #       appointment.update_attribute(:status, 0)
  #     else
  #       appointment.update_attribute(:status, 1)
  #     end
  #   end
  # end

end
