class UpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'appointments_job_queue'

  def perform(user_id)
    user = User.find(user_id)
    @appointments = user.doctor_appointments if user.patient?
    @appointments = user.patient_appointments if user.doctor?
    @appointments.each do |appointment|
      appointment.update_attribute(:status, :unvisited) if appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
    end
  end 

end
