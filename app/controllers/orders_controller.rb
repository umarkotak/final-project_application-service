class OrdersController < ApplicationController
  def index
    
  end

  def new
    @user = User.find(session[:user_id])
  end

  def create
    
  end

  private
end
