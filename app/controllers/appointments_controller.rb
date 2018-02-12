class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]  

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
    @check_status = Appointment.where(status: 0)
    perform_update(@check_status)
  end

  def new
    # binding.pry
    @appointment = Appointment.new
    @note = @appointment.notes.build({user_id: current_user.id})
    @all_doctors = User.getalldoctors
    # @image = @appointment.images.build
    
  end

  # def available_slots
  #   @available_slots = []
  #   curr_app_date = params[:selected_date]
  #   occupied_slots = formatted_appointment_slots(Appointment.available_appointment_slots(curr_app_date))
  #   @available_slots = TOTAL_SLOTS - occupied_slots
    
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  def create
    @appointment = Appointment.new(appointments_params)
    @appointment.patient_id = current_user.id
    @appointment.notes.first.user_id = current_user.id
    @all_doctors = User.getalldoctors
    # @image = @appointment.build_image({imagable_id: params[:id]})
    
    # @image = @appointment.images.build
    # if params[:time_slot].nil?
    #   flash["alert"] = "Please choose a time slot"
    #   render 'new' and return
    # end 

    # @appointment.starting_time = params[:time_slot]
    # @appointment.ending_time = @appointment.starting_time + 1.hour

    if @appointment.save
      flash[:notice] = "Appointment saved!"
      redirect_to authenticated_root_path
    else
      render 'new'
    end
  end

  def edit
    @appointment = Appointment.find(params[:id])
    @all_doctors = User.getalldoctors
    # @image = @appointment.images
    @note = @appointment.notes.first
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.status = get_current_status(@appointment.date)
    @all_doctors = User.getalldoctors
    # @appointment.starting_time = params[:time_slot]
    # @appointment.ending_time = @appointment.starting_time + 1.hour
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

  def update_status
    @appointment = Appointment.find(params[:id])
    # if @appointment.date > Time.now
      @appointment.status = 2
      # time_slot = @appointment.starting_time
      # @available_slots << time_slot
    # end

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
      flash[:notice] = 'visited'
      redirect_to appointments_path
    else
      render authenticated_root_path
    end 
  end 

  def perform_update(appointments)
    # Do something
    appointments.each do |appointment|
        # if appointment.cancelled? or appointment.visited?
        #   next
        # elsif appointment.date.strftime("%Y-%m-%d") === Time.now.strftime("%Y-%m-%d") || appointment.date > Time.now
        #   appointment.update_attribute(:status, :pending)
        # elsif appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
        #   appointment.update_attribute(:status, :completed)
        # else
        #   appointment.update_attribute(:status, :visited)
        # end
        
        if appointment.date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
          appointment.update_attribute(:status, :unvisited)
        end
        
    end
  end

  def archive
    @archives = current_user.past_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
  end

  

  def formatted_appointment_slots(slots)
    slots.map{ |k| k.strftime("%H:%M") if k.present? }
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :image, :starting_time,
        # images_attributes: [:id, :imagable_id, :imagable_type, :image, :_destroy],
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

    def get_current_status(date)
      return 0 if date > Time.now
      return 1
    end

end
