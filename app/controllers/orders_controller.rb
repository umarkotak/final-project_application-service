class OrdersController < ApplicationController
  def index
    
  end

  def new
    @order = Order.new
    @user = User.find(session[:user_id])
  end

  def confirm_order
    
  end

  def create
    redirect_to orders_path
  end

  private
end
