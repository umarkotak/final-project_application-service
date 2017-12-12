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
      @order.user_id = session[:user_id]
      @order.driver_id = @driver.try(:id)

      @origin = @order.get_coordinate(@order.origin)
      @destination = @order.get_coordinate(@order.destination)

      session[:temp_data] = @order

      @status = true
    else
      @status = false
    end
  end

  def create
    @temp_data = session[:temp_data]
    @order = Order.new(order_params)
    @order.set_order_data(@temp_data)

    puts "DATA TEST #{@temp_data.to_json}"
    puts "DATA TEST #{@order.to_json}"

    @driver_location = DriverLocation.find_by(driver_id: @order.driver_id)
    @driver_location.status = 'busy'

    @order.save
    @driver_location.order_id = @order.id
    @driver_location.save

    session[:temp_data] = nil
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

