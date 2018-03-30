class Ability
  include CanCan::Ability
  def initialize(user)
    can [:update, :destroy], Note do |note|
        note.user_id == user.id
    end
    if user.patient?
      can :create, Appointment
      can [:update, :destroy], Appointment do |appointment|
        appointment.patient == user && appointment.pending?
      end
      can :show, Appointment do |appointment|
        appointment.patient == user
      end
    elsif user.doctor?
      can :show, Appointment do |appointment|
        appointment.doctor == user
      end
      can [:update, :destroy], Appointment do |appointment|
        appointment.doctor == user && appointment.pending?
      end
    end
  end
end
