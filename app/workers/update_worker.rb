class UpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'appointments_job_queue'

  def perform(appointments)
    appointments.each do |appointment|
      appointment.update_attribute(:status, :unvisited) if appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
    end
  end 

end
