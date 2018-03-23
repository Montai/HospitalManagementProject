class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    can :read, :all
    can :update, Appointment if user.patient?
    can :update, Note, Note.where('user_id = :current_user_id', current_user_id: user.id) do |note|
        note.user_id == user.id
    end
    cannot :update, Appointment, Appointment.where('date < :current_date', current_date: Time.now) do |appointment|
      appointment.date < Time.now
    end
    cannot :destroy, Appointment, Appointment.where('date < :current_date', current_date: Time.now) do |appointment|
      appointment.date < Time.now
    end 
  end
end
