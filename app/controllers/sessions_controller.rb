class SessionsController < Devise::SessionsController

	protected

	    def after_sign_in_path_for(resource)
	      '/appointments'
	    end

end
