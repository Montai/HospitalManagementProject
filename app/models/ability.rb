class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    can :update, Appointment if user.patient?
    can :update, Note, Note.where('user_id = ?', user.id) do |note|
        note.user_id == user.id
    end
    cannot :update, Appointment, Appointment.where('date < ?', Time.now) do |appointment|
      appointment.date < Time.now
    end
  end
end
