class OrdersController < ApplicationController
  def index
    
  end

  def new
    @order = Order.new
    @user = User.find(session[:user_id])
  end

  def confirm_order
    @order = Order.new(order_params)
    @drivers = @order.show_available_drivers

    if @order.calculate_data(@order.origin, @order.destination)
      @origin = @order.get_coordinate(@order.origin)
      @destination = @order.get_coordinate(@order.destination)
      @status = true
    else
      @status = false
    end

  end

  def create
    redirect_to orders_path
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :driver_id, :origin, :destination, :distance, :service_type, :payment_type, :price, :status)
    end
end
