class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_logged_user
  protect_from_forgery with: :exception

  protected
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: 'Please Login'
      end
    end

    def set_logged_user
      @logged_user = User.find_by(id: session[:user_id])
    end
end
