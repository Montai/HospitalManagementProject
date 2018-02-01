class AppointmentsController < ApplicationController

  before_action :is_patient?, only:[:new, :create]

  def index
    @appointments = current_user.future_appointments.paginate(page: params[:page], per_page: PAGINATION_PAGES)
    update_appointment_date
  end

  def new
    @appointment = Appointment.new
    # @image = @appointment.images.build
    @note = @appointment.notes.build({user_id: current_user.id})
    @all_users = User.getalldoctors
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

  # def set_date
  #   @appointment = Appointment.find(params[:id])
  #   @appointment.date = params[:my_date]
  # end 

  def create
    @appointment = Appointment.new(appointments_params)
    @appointment.patient_id = current_user.id
    @appointment.status = 'pending'
    @all_users = User.getalldoctors
    @appointment.starting_time = params[:time_slot]

    # @available_slots = []
    # curr_app_date = @appointment.date
    # occupied_slots = formatted_appointment_slots(Appointment.available_appointment_slots)
    # available_slots = TOTAL_SLOTS - occupied_slots

    # (10...20).each do |i|
    #   @available_slots << "#{i}:00"
    # end

    # @appointments = Appointment.all_pending_appointments
    # curr_date = @appointment.date.strftime("%B %d, %Y")
    # @appointments.each do |appointment|
    #   if appointment.date.strftime("%B %d, %Y") == curr_date
    #     (10...20).each do |t|
    #       if appointment.starting_time.to_s(:time) == "#{t}:00"
    #         @available_slots.
    #       end
    #     end
    #   end
    # end


    # if check_appointment_collision(@appointment) == true
    #   flash[:notice] = "Already appointed/ Time slot taken, please choose different time"
    #   @all_users = User.getalldoctors
    #   render 'new' and return
    # end

    if @appointment.save
      flash[:notice] = "Appointment saved!"
      redirect_to authenticated_root_path
    else
      flash[:notice] = "Opps!"
      render 'new'
    end
  end

  # def set
  #   @appointment = Appointment.find(params[:id])
  #   if params[:appointment] == "10:00"
  #     flash[:notice] = "Setted Starting Time"
  #     @appointment.starting_time = "10:00"
  #   end 
  # end 

  def update_status
    @appointment = Appointment.find(params[:id])
    if @appointment.date > Time.now
      @appointment.status = 2
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
    @appointment = Appointment.find(params[:id])
    @all_users = User.getalldoctors
  end

  def update
    @appointment = Appointment.find(params[:id])
    @appointment.status = get_current_status(@appointment.date)
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
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to authenticated_root_path
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def formatted_appointment_slots(slots)
    slots.map{|k| k.strftime("%H:%M") if k.present?}
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id, :starting_time,
        # images_attributes: [:id, :imagable_id, :imagable_type, :image, :_destroy],
        notes_attributes: [:id, :description, :user_id, :_destroy])
    end

    def update_appointment_date
      @appointments.each do |appointment|
        if appointment.cancelled?
          next
        elsif appointment.date > Time.now
          appointment.update_attribute(:status, :pending)
        else
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

    # def check_appointment_collision(current_appointment)
    #   @appointments = Appointment.all_pending_appointments
    #   @appointments.each do |appointment|
    #     if current_appointment.doctor.first_name == appointment.doctor.first_name &&
    #       current_appointment.patient.first_name == appointment.patient.first_name &&
    #       current_appointment.date.strftime("%B %d, %Y") == appointment.date.strftime("%B %d, %Y")

    #       return true
    #     end

    #     if current_appointment.doctor.first_name == appointment.doctor.first_name &&
    #        current_appointment.patient.first_name != appointment.patient.first_name &&
    #        current_appointment.date.strftime("%B %d, %Y") == appointment.date.strftime("%B %d, %Y") &&
    #        (current_appointment.starting_time.to_s(:time) >= appointment.starting_time.to_s(:time) && current_appointment.starting_time.to_s(:time) >= appointment.ending_time.to_s(:time))

    #        return true

    #     end
    #   end

    #     return false
    # end

end
