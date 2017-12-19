class OrdersController < ApplicationController
  before_action :set_order, only: [:destroy]
  before_action :initiate_kafka, only: [:micro_order]
  skip_before_action :verify_authenticity_token, only: [:micro_order]

  def index
    @orders = Order.all.order(id: :desc)
  end

  def new
    @order = Order.new
    @any_order = Order.where("user_id = '#{session[:user_id]}'").find_by(status: 'on_process')
    @driver = Driver.find(@any_order.driver_id) if @any_order.try(:driver_id)
  end

  def confirm_order
    @order  = Order.new(order_params)

    if @order.get_cached_routes
      @order.set_price
      @order.user_id = session[:user_id]

      session[:temp_data] = @order
      session[:referer] = request.fullpath

      @status = true
    else
      route_status = @order.validate_route(@order.origin, @order.destination)
      if route_status
        @order.set_distance(route_status)
        @order.set_price
        @order.user_id = session[:user_id]
        @order.set_cached_routes

        session[:temp_data] = @order
        session[:referer] = request.fullpath

        @status = true
      else
        @status = false
      end
    end
  end

  def micro_order
    @message[:action] = 'get_driver'

    @temp_data = session[:temp_data]
    @order = Order.new(order_params)
    @order.set_order_data(@temp_data)

    status = true
    if @order.payment_type == 'gopay'
      status = @order.check_gopay(session[:user_id])
    end

    if status
      @order.save
      @message[:order_id] = @order.id
      @message[:service_type] = @order.service_type
      
      if @order.get_cached_routes
        @message[:origin] = @order.get_cached_routes
      else
        @message[:origin] = @order.get_coordinate(@order.origin)
      end

      session[:temp_data] = nil

      @kafka.deliver_message("#{@message}", topic: 'driver_location')
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

    def initiate_kafka
      @kafka = Kafka.new(
        seed_brokers: ['127.0.0.1:9092'],
        client_id: 'goride',
      )
      @message = {}
    end
end

