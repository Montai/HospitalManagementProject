class RegistrationsController < Devise::RegistrationsController
	
	protected 

		def after_sign_up_path_for(resource)
			'/appointments'
		end 
	
	private

		def sign_up_params
			params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation)
		end

		def account_update_params
	   		params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation,:current_password)
	  	end

end
