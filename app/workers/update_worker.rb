class UpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'appointments_job_queue'

  def perform
    all_past_appointments = Appointment.where('date < :current_date OR status = :cancelled', current_date: Time.now, cancelled: Appointment.statuses[:cancelled])
    all_past_appointments.update_all(status: "unvisited")
  end
end
