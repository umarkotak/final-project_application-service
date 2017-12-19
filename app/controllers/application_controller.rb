class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_logged_user
  before_action :set_logged_driver
  before_action :driver_job_notification
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

    def driver_job_notification
      if @logged_driver
        request = request_json("http://localhost:3001/driver_locations")
        @notification = false
        request.each do |driver_location|
          @notification = driver_location if driver_location['driver_id'] == session['driver_id'] && driver_location['status'] == 'busy'
        end
      end
    end

    def request_json(url)
      request = HTTP.get(url).to_s
      request = JSON.parse(request)
    end
end
