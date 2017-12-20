class SessionsController < ApplicationController
  skip_before_action :authorize
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:driver_id] = nil
      redirect_to user_path(user.id)
    else
      redirect_to login_path, alert:"invalid username/password combination"
    end
  end

  def new_driver
  end

  def create_driver
    driver = Driver.find_by(username: params[:username])
    if driver.try(:authenticate, params[:password])
      session[:driver_id] = driver.id
      session[:user_id] = nil
      redirect_to driver_path(driver.id)
    else
      redirect_to login_driver_path, alert:"invalid driver username/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:driver_id] = nil
    redirect_to login_path, notice: "Logged out"
  end

end
