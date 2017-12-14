class OrdersController < ApplicationController
  before_action :set_order, only: [:destroy]

  def index
    @orders = Order.all.order(id: :desc)
  end

  def new
    @order = Order.new
    @any_order = Order.where("user_id = '#{session[:user_id]}'").find_by(status: 'on_process')
  end

  def confirm_order
    @order  = Order.new(order_params)
    @driver = Driver.get_available_drivers(@order.service_type)

    route_status = @order.validate_route(@order.origin, @order.destination)
    if route_status
      @order.set_distance(route_status)
      @order.set_price
      @order.user_id = session[:user_id]
      @order.driver_id = @driver.try(:id)

      # @origin = @order.get_coordinate(@order.origin)
      # @destination = @order.get_coordinate(@order.destination)

      session[:temp_data] = @order
      session[:referer] = request.fullpath

      @status = true
    else
      @status = false
    end
  end

  def create
    @temp_data = session[:temp_data]
    @order = Order.new(order_params)
    @order.set_order_data(@temp_data)

    status = true
    if @order.payment_type == 'gopay'
      status = @order.check_gopay(session[:user_id])
    end

    if status
      @order.save
      @driver_location = DriverLocation.find_by(driver_id: @order.driver_id)
      @driver_location.order_id = @order.id
      @driver_location.status = 'busy'
      @driver_location.save
      session[:temp_data] = nil

      redirect_to new_order_path
    else
      redirect_to session[:referer], notice: 'Your credit is insuficient, please top up'
    end
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

