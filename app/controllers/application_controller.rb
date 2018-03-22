class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected
  
    def is_patient?
      redirect_to '/' and return if current_user.blank?
      redirect_to '/', notice: 'Invalid Authorization' and return unless current_user.patient?
      return if current_user.patient?
    end
end
