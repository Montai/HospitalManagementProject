class ImagesController < ApplicationController 

	def show
		# @appointment = Appointment.find(params[:appointment_id])
		@image = Image.where('imagable_id = ?', params[:appointment_id])
	end 

end
