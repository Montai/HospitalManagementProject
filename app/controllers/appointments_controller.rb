class AppointmentsController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.doctor?
      @appointments = Appointment.where(doctor_id: current_user.id).order('created_at DESC')
    else
      @appointments = Appointment.where(patient_id: current_user.id).order('created_at DESC')
    end
  end

  def new
    @appointment = Appointment.new
    if current_user.patient?
      @all_users = User.all.select('id, first_name').doctor
    else
      @all_users = User.all.select('id, first_name').patient
    end
  end

  def create
    @appointment = Appointment.new(appointments_params)
    curr_time = Time.now

    if current_user.patient?
      @appointment.patient_id = current_user.id
      if @appointment.date > curr_time
        @appointment.status = 'pending'
      else
        @appointment.status = 'closed'
      end
    else
      @appointment.doctor_id = current_user.id
      if @appointment.date > curr_time
        @appointment.status = 'pending'
      else
        @appointment.status = 'closed'
      end
    end

    if @appointment.save
      flash[:notice] = "Appointment saved!"
      redirect_to root_path
    else
      flash[:alert] = "Opps!"
      render 'new'
    end
  end

  def update_status
    @appointment = Appointment.find(params[:id])
    if @appointment.date > Time.now
      @appointment.status = 'cancelled'
    end

    if @appointment.save
      flash[:notice] = 'status changed!'
      redirect_to appointment_path(@appointment)
    else
      render root_path
    end
  end

  def archive
    @archives = Appointment.where('status = ?','closed').order('created_at DESC')
  end

  def edit
    @appointment = Appointment.find(params[:id])
    if current_user.patient?
      @all_users = User.all.select('id, first_name').doctor
    else
      @all_users = User.all.select('id, first_name').patient
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    curr_time = Time.now

    if current_user.patient?
      @appointment.patient_id = current_user.id
      if @appointment.date > curr_time
        @appointment.status = 'pending'
      else
        @appointment.status = 'closed'
      end
    else
      @appointment.doctor_id = current_user.id
      if @appointment.date > curr_time
        @appointment.status = 'pending'
      else
        @appointment.status = 'closed'
      end
    end

    if @appointment.update(appointments_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to root_path
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

    def appointments_params
      params.require(:appointment).permit(:date, :doctor_id, :patient_id)
    end

end
