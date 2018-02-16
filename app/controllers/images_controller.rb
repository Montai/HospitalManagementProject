class ImagesController < ApplicationController 

	def show
	  @image = Image.where('imagable_id = ?', params[:appointment_id])
	end 

end
