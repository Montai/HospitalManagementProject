class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]  
  before_action :check_user, only:[:edit]

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
    @curr_appointments = Appointment.where(status: 0)
    perform_update(@curr_appointments)
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
      flash[:notice] = "Appointment saved!"
      redirect_to authenticated_root_path
    else
      render 'new'
    end
  end

  def check_user
    @appointment = Appointment.find(params[:id])
    if current_user.doctor? or current_user.id != @appointment.patient_id
      redirect_to authenticated_root_path and return
    end 
    unless current_user.patient? and current_user.id == @appointment.patient_id
      redirect_to edit_appointment_path(@appointment)
    end         
  end 

  def edit
    @appointment = Appointment.find(params[:id])
    @all_doctors = User.getalldoctors
    @note = @appointment.notes.first
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.status = get_current_status(@appointment.date)
    @all_doctors = User.getalldoctors
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

  def cancel_appointment
    @appointment = Appointment.find(params[:id])
    @appointment.status = 2
     
    if @appointment.save
      flash[:notice] = 'appointment cancelled!'
      redirect_to appointments_path
    else
      render authenticated_root_path
    end
  end

  def visited_patient_appointment 
    @appointment = Appointment.find(params[:id])
    @appointment.status = 3
    if @appointment.save 
      flash[:notice] = 'appointment visited'
      redirect_to appointments_path
    else
      render authenticated_root_path
    end 
  end 

  def perform_update(appointments)
    # Do something
    appointments.each do |appointment|
      if appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
        appointment.update_attribute(:status, :unvisited)
      end
    end
  end

  def archive
    @archives = current_user.past_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
  end

  def get_current_status(date)
    return 0 if date > Time.now
    return 1
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :image, :starting_time,
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

end
