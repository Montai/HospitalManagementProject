class RegistrationsController < Devise::RegistrationsController
  private
  #Permit attributes
  def sign_up_params
	  params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation)
	end

	def account_update_params
	  params.require(:user).permit(:first_name,:last_name,:gender,:date_of_birth,:role,:email,:password,:password_confirmation,:current_password)
	end
end
