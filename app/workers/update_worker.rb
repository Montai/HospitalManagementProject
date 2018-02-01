class UpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'appointments_job_queue'

  def perform(appointments)
    # Do something
    appointments.each do |appointment|
        if appointment.cancelled?
          next
        elsif appointment.date > Time.now
          appointment.update_attribute(:status, :pending)
        else
          appointment.update_attribute(:status, :completed)
        end
    end
  end

end
