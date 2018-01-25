class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]
  # before_action :set_time_zone


  def index
    @appointments = show_my_upcoming_appointments
    # @appointments.each do |appointment|
    #   if appointment.status == 2
    #     next
    #   elsif  appointment.date > Time.now
    #     appointment.update_attribute(:status, :pending)
    #   else appointment.date
    #     appointment.update_attribute(:status, :completed)
    #   end
    # end
  end

  def new
    @appointment = Appointment.new
    # @image = @appointment.images.build
    @note = @appointment.notes.build({user_id: current_user.id})
    @all_users = User.getalldoctors
  end

  def create
    @appointment = Appointment.new(appointments_params)

    @appointment.patient_id = current_user.id
    @appointment.status = get_current_status(@appointment.date)

    if @appointment.save
      flash[:notice] = "Appointment saved!"
      redirect_to authenticated_root_path
    else
      flash[:alert] = "Opps!"
      render 'new'
    end
  end

  def update_status
    @appointment = Appointment.find(params[:id])
    if @appointment.date > Time.now
      @appointment.status = 2
    end

    if @appointment.save
      flash[:notice] = 'status changed!'
      redirect_to appointment_path(@appointment)
    else
      render authenticated_root_path
    end
  end

  def archive
    @archives = show_my_previous_appointments
  end

  def edit
    @appointment = Appointment.find(params[:id])
    if current_user.patient?
      @all_users = User.getalldoctors
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.status = get_current_status(@appointment.date)
    if @appointment.update(appointments_params)
      flash[:notice] = "Updated successfully!"
      redirect_to authenticated_root_path
    else
      flash[:alert] = "opps!"
      render 'edit'
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to authenticated_root_path
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id,
        # images_attributes: [:id, :imagable_id, :imagable_type, :image, :_destroy],
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

    def get_current_status(date)
      if date > Time.now
        return 0
      else
        return 1
      end
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
