class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]
  before_action :search_appointment, only:[:update_status, :edit, :update, :destroy, :show]
  

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
    UpdateWorker.perform_async(@appointments)
  end

  def new
    @appointment = Appointment.new
    @note = @appointment.notes.build({user_id: current_user.id})
    @image = @appointment.images.build
    @all_doctors = User.getalldoctors
  end

  def available_slots
    @available_slots = []
    curr_app_date = params[:selected_date]
    occupied_slots = formatted_appointment_slots(Appointment.available_appointment_slots(curr_app_date))
    @available_slots = TOTAL_SLOTS - occupied_slots
    
    respond_to do |format|
      format.js
    end
  end

  def create
    @appointment = Appointment.new(appointments_params)
    @appointment.patient_id = current_user.id
    @all_doctors = User.getalldoctors

    if params[:time_slot].nil?
      flash["alert"] = "Please choose a time slot"
      render 'new' and return
    end 

    @appointment.starting_time = params[:time_slot]
    @appointment.ending_time = @appointment.starting_time + 1.hour

    if @appointment.save
      flash[:notice] = "Appointment saved!"
      redirect_to authenticated_root_path
    else
      flash[:notice] = "Opps!"
      render 'new'
    end
  end

  def update_status
    if @appointment.date > Time.now
      @appointment.status = 2
      time_slot = @appointment.starting_time
      @available_slots << time_slot
    end

    if @appointment.save
      flash[:notice] = 'appointment cancelled!'
      redirect_to appointment_path(@appointment)
    else
      render authenticated_root_path
    end
  end

  def archive
    @archives = current_user.past_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
  end

  def edit
    @all_doctors = User.getalldoctors
  end

  def update
    @appointment.status = get_current_status(@appointment.date)
    @all_doctors = User.getalldoctors
    @appointment.starting_time = params[:time_slot]
    @appointment.ending_time = @appointment.starting_time + 1.hour
    if @appointment.update(appointments_params)
      flash[:notice] = "Updated successfully!"
      redirect_to authenticated_root_path
    else
      flash[:alert] = "opps!"
      render 'edit'
    end
  end

  def destroy
    @appointment.destroy
    redirect_to authenticated_root_path
  end

  def show
    @image = Image.where('imagable_id = ?', @appointment.id)
  end

  def formatted_appointment_slots(slots)
    slots.map{ |k| k.strftime("%H:%M") if k.present? }
  end

  private

    def search_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :starting_time,
        images_attributes: [:id, :imagable_id, :imagable_type, :image, :_destroy],
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

    def get_current_status(date)
      return 0 if date > Time.now
      return 1
    end

end
