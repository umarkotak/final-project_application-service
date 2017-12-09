class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_logged_user
  before_action :set_logged_driver
  protect_from_forgery with: :exception

  protected
    def authorize
      unless User.find_by(id: session[:user_id]) || Driver.find_by(id: session[:driver_id])
        redirect_to login_url, notice: 'Please Login'
      end
    end

    def set_logged_user
      @logged_user = User.find_by(id: session[:user_id])
    end

    def set_logged_driver
      @logged_driver = Driver.find_by(id: session[:driver_id])
    end
end
