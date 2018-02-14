class SessionsController < Devise::SessionsController
	def after_sign_in_path_for(resource)
      appointments_path
    end

    # def new 
    # 	self.resource = resource_class.new(sign_in_params) 
    # 	clean_up_passwords(resource) 
    # 	redirect_to appointments_path 
    # end
end
