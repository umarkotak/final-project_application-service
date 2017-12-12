class OrdersController < ApplicationController
  before_action :set_order, only: [:destroy]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    @user = User.find(session[:user_id])
  end

  def confirm_order
    @order = Order.new(order_params)
    @driver = @order.show_available_drivers

    if @order.calculate_data(@order.origin, @order.destination)
      @origin = @order.get_coordinate(@order.origin)
      @destination = @order.get_coordinate(@order.destination)
      @status = true
    else
      @status = false
    end
  end

  def create
    @order = Order.new(order_params)
    @order.calculate_data(@order.origin, @order.destination)
    @order.status = 'on_progress'

    @driver_location = DriverLocation.find_by(driver_id: @order.driver_id)
    @driver_location.status = 'busy'

    if @order.save
      @driver_location.order_id = @order.id
      @driver_location.save
      redirect_to orders_path
    else

    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :driver_id, :origin, :destination, :distance, :service_type, :payment_type, :price, :status)
    end
end

