class NotesController < ApplicationController

  def new
    @appointment = Appointment.new
    @note = @appointment.notes.build
  end

  def create
    @appointment = Appointment.find(params[:appointment_id])
    @note = @appointment.notes.new(notes_params)
    @note.user_id = current_user.id
    # if current_user.patient?
    #   creator = @appointment.patient.first_name
    # else
    #   creator = @appointment.doctor.first_name
    # end
    if @note.save
      flash[:notice] = "Saved successfully!"
      redirect_to appointment_path(@appointment)
    else
      render 'new'
    end
  end

  def show
      @appointment = Appointment.find(params[:appointment_id])
      # if current_user.patient?
      #   creator = @appointment.patient.first_name
      # else
      #   creator = @appointment.doctor.first_name
      # end
  end

  def destroy
    @appointment = Appointment.find(params[:appointment_id])
    @note = @appointment.notes.find(params[:id])
    @note.destroy
    redirect_to appointment_path(@appointment)
  end

  def edit
    @appointment = Appointment.find(params[:appointment_id])
    @note = @appointment.notes.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:appointment_id])
    @note = @appointment.notes.find(params[:id])
    if @note.update(notes_params)
      flash[:notice] = "Updated"
      redirect_to appointment_path(@appointment)
    else
      flash[:alert] = "Opps!"
      render 'edit'
    end
  end

  private

    def notes_params
      params.require(:note).permit(:description)
    end

end
