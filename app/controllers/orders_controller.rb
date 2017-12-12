class OrdersController < ApplicationController
  before_action :set_order, only: [:destroy]

  def index
    @orders = Order.all.order(id: :desc)
  end

  def new
    @order = Order.new
  end

  def confirm_order
    @order  = Order.new(order_params)
    @driver = @order.get_available_drivers

    route_status = @order.validate_route(@order.origin, @order.destination)
    if route_status
      @order.set_distance(route_status)
      @order.set_price

      @origin = @order.get_coordinate(@order.origin)
      @destination = @order.get_coordinate(@order.destination)

      @status = true
    else
      @status = false
    end
  end

  def create
    @order = Order.new(order_params)
    @order.status = 'on_progress'

    @driver_location = DriverLocation.find_by(driver_id: @order.driver_id)
    @driver_location.status = 'busy'

    @order.save
    @driver_location.order_id = @order.id
    @driver_location.save

    redirect_to orders_path
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
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

