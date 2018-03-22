class NotesController < ApplicationController
  #Callbacks
  before_action :check_user, only:[:edit, :destroy]
  before_action :find_current_notes_appointment, except: [:new]
  def new
    @appointment = Appointment.new
    @note = @appointment.notes.build
  end

  def create
    @note = @appointment.notes.new(notes_params)
    @note.user_id = current_user.id
    if @note.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to appointments_path(@appointment), notice: 'Unable to add note, try again!'
    end
  end

  def show
  end

  def destroy
    @note = @appointment.notes.find(params[:id])
    @note.destroy
    redirect_to appointment_path(@appointment), notice: 'Note destroyed!'
  end

  def edit
    @note = @appointment.notes.find(params[:id])
  end

  def update
    @note = @appointment.notes.find(params[:id])
    if @note.update(notes_params)
      redirect_to appointment_path(@appointment), notice: 'Updated Note'
    else
      render 'edit', notice: 'Sorry, Unable to update Note, Please try again!'
    end
  end

  private

    def notes_params
      params.require(:note).permit(:description)
    end

    def find_current_notes_appointment
      @appointment = Appointment.find(params[:appointment_id])
    end 

    #Method to restrict current user to edit/update other users Note
    def check_user
      @appointment = Appointment.find(params[:appointment_id])
      @note = @appointment.notes.find(params[:id])
      redirect_to root_path and return if current_user.id != @note.user_id or @appointment.date < Time.now
    end
end
