class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]  
  before_action :check_user, only:[:edit, :show]

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES) 
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

    if @appointment.save
      @curr_appointments = Appointment.where('status = ?',Appointment.statuses[:pending])
      UpdateWorker.perform_async(@curr_appointments)
      redirect_to authenticated_root_path, notice: "Appointment saved!"
    else
      render 'new', notice: "Unable to create Appointment, Try again!"
    end
  end

  def check_user
    @appointment = Appointment.find(params[:id])
    if current_user.doctor? or current_user.id != @appointment.patient_id
      then redirect_to authenticated_root_path and return
    end 
    unless current_user.patient? and current_user.id == @appointment.patient_id
      redirect_to edit_appointment_path(@appointment)
    end         
  end 

  def edit
    @appointment = Appointment.find(params[:id])
    @all_doctors = User.getalldoctors
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.status = get_current_status(@appointment.date)
    @all_doctors = User.getalldoctors
    if @appointment.update(appointments_params)
      redirect_to authenticated_root_path, notice: "Updated successfully!"
    else
      render 'edit', notice: "Unable to save Appointment, Try again!"
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to authenticated_root_path, notice: "Appointment Deleted!"
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def cancel_appointment
    @appointment = Appointment.find(params[:id])
    @appointment.status = Appointment.statuses[:cancelled]
     
    if @appointment.save
      redirect_to appointments_path, notice: "Appointment Cancelled!"
    else
      render authenticated_root_path, notice: "Unable to cancel, try again!"
    end
  end

  def visited_patient_appointment 
    @appointment = Appointment.find(params[:id])
    @appointment.status = Appointment.statuses[:visited]
    if @appointment.save 
      redirect_to appointments_path, notice: "Appointment Visited!"
    else
      render authenticated_root_path, notice: "Unable to change status, try again!"
    end 
  end 

  def perform_update(appointments)
    # Grab appointments and change status if date is passed 
    appointments.each do |appointment|
      appointment.update_attribute(:status, :unvisited) if appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
    end
  end

  def archive
    @archives = current_user.past_appointments
    respond_to do |format|
      format.html
      format.js
    end 
  end

  def get_current_status(date)
    return Appointment.statuses[:pending] if date > Time.now
    return Appointment.statuses[:unvisited]
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :image,
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

end
