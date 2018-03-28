desc 'update appointment task'
task update_appointment_task: :environment do
  UpdateWorker.perform_async()
end
