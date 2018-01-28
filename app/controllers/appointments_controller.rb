class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]


  def index
    @appointments = current_user.future_appointments
    update_appointment_date
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
    @appointment.status = 'pending'

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
    @archives = current_user.past_appointments
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

    def update_appointment_date
      @appointments.each do |appointment|
        if appointment.cancelled?
          next
        elsif  appointment.date > Time.now
          appointment.update_attribute(:status, :pending)
        else appointment.date
          appointment.update_attribute(:status, :completed)
        end
      end
    end

    def get_current_status(date)
      if date > Time.now
        return 0
      else
        return 1
      end
    end

end
