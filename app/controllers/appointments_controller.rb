class AppointmentsController < ApplicationController
  #Callbacks
  before_action :is_patient?, only: [:new, :create]
  before_action :check_user, only: [:edit]
  before_action :find_current_appointment, except: [:index, :new, :create, :archive]

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @appointment = Appointment.new
    @note = @appointment.notes.build({user_id: current_user.id})
    @all_doctors = User.getalldoctors
  end

  def create
    @appointment = Appointment.new(appointments_params)
    @appointment.patient_id = current_user.id
    @appointment.notes.first.user_id = current_user.id
    @all_doctors = User.getalldoctors
    UpdateWorker.perform_async(current_user.id)
    if @appointment.save
      redirect_to root_path, notice: 'Appointment saved!'
    else
      render 'new', notice: 'Unable to create Appointment, Try again!'
    end
  end

  def edit
    @all_doctors = User.getalldoctors
  end

  def update
    @appointment.status = get_current_status(@appointment.date)
    @all_doctors = User.getalldoctors
    if @appointment.update(appointments_params)
      redirect_to root_path, notice: 'Updated successfully!'
    else
      render 'edit', notice: 'Unable to save Appointment, Try again!'
    end
  end

  def destroy
    @appointment.destroy
    redirect_to root_path, notice: 'Appointment Deleted!'
  end

  def show
  end

  #Method used to cancel a patient appointment
  def cancel_appointment
    @appointment.status = Appointment.statuses[:cancelled]
    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment Cancelled!'
    else
      render root_path, notice: 'Unable to cancel, try again!'
    end
  end

  #Method used to approve an Appointment by changing the status to Visited
  def visited_patient_appointment
    @appointment.status = Appointment.statuses[:visited]
    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment Visited!'
    else
      render root_path, notice: 'Unable to change status, try again!'
    end
  end

  #Show all the unvisited past appointments
  def archive
    @archives = current_user.past_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
  end

  #Method to get the current status according to Appointment Date
  def get_current_status(date)
    return Appointment.statuses[:pending] if date > Time.now
    return Appointment.statuses[:unvisited]
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :image, :slot_tag,
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

    def find_current_appointment
      @appointment = Appointment.find(params[:id])
    end 

    #Method to restrict current user to edit/update other users appointment
    def check_user
      @appointment = Appointment.find(params[:id])
      if current_user.doctor? or current_user.id != @appointment.patient_id or @appointment.date < Time.now
        then redirect_to root_path and return
      end
      unless current_user.patient? and current_user.id == @appointment.patient_id
        redirect_to edit_appointment_path(@appointment)
      end
    end
end
