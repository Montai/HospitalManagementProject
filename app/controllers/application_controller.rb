class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!

  protected

    def is_patient?
      return if current_user.blank?
      return if current_user.patient?
    end

    def is_doctor?
      return if current_user.blank?
      return if current_user.doctor?
    end
end
