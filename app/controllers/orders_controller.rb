class OrdersController < ApplicationController
  def index
    
  end

  def new
    @order = Order.new
    @user = User.find(session[:user_id])
  end

  def confirm_order
    @order = Order.new(order_params)
    @origin = @order.get_coordinate(@origin)

    @destination = {
      :lat => "lat",
      :lng => "lng"
    }

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
