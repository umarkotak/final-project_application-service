class DriversController < ApplicationController
  skip_before_action :authorize, only:[:create, :new]
  before_action :set_driver, only: [:show, :edit, :update, :destroy, :topup, :set_topup]
  before_action :authenticate, only: [:show, :edit]
  before_action :initiate_kafka, only: [:do_job]

  def index
    @drivers = Driver.all
  end

  def show
  end

  def new
    @driver = Driver.new
  end

  def edit
  end

  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to login_driver_path, notice: 'Driver was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
    end
  end

  def topup
  end

  def set_topup
    res = @driver.topup(params[:topup_amount])
    
    respond_to do |format|
      if @driver.save && res
        format.html { redirect_to topup_driver_path, notice: 'Top up success.' }
      else
        format.html { redirect_to topup_driver_path, notice: 'Top up failed: amount is invalid' }
      end
    end
  end

  def job
    request = request_json("http://localhost:3001/driver_locations")
    @driver_location = request.find { |hash| hash['driver_id'].to_i == session[:driver_id] }
    @order = Order.find_by(id: @driver_location['order_id']) if @driver_location

    @finished_orders = Order.where(driver_id: session[:driver_id]).order(id: :desc)
  end

  def do_job  
    request = request_json("http://localhost:3001/driver_locations")
    @driver_location = request.find { |hash| hash['driver_id'].to_i == session[:driver_id] }

    @order = Order.find_by(id: @driver_location['order_id'])
    @order.status = params[:status]

    @message[:action] = 'set_driver_location_done'
    @message[:driver_id] = session[:driver_id]
    if @order.status == 'completed'
      Driver.complete_job(@order)

      @message[:location] = @order.destination
      @message[:coordinate] = get_coordinate(@order.destination)
    else
      @message[:location] = @order.origin
      @message[:coordinate] = get_coordinate(@order.origin)
    end

    respond_to do |format|
      if @order.save
        @kafka.deliver_message("#{@message}", topic: 'driver_location')
        
        format.html { redirect_to job_driver_path(session[:driver_id]), notice: "Order #{@order.status}" }
      else
        format.html { redirect_to job_driver_path(session[:driver_id]), notice: 'Something wrong' }
      end
    end 
  end

  private
    def set_driver
      @driver = Driver.find(params[:id])
    end

    def driver_params
      params.require(:driver).permit(:username, :password, :full_name, :email, :phone, :address, :service_type, :credit)
    end

    def authenticate
      if session[:driver_id]
        redirect_to driver_path(session[:driver_id]) if @driver.id != session[:driver_id]
      elsif session[:user_id]
        redirect_to user_path(session[:user_id])
      end
    end

    def initiate_kafka
      @kafka = Kafka.new(
        seed_brokers: ['127.0.0.1:9092'],
        client_id: 'goride',
      )
      @message = {}
    end

    def request_json(url)
      request = HTTP.get(url).to_s
      request = JSON.parse(request)
    end

    def apikey
      "AIzaSyAxXs-AipMveHRNInl7P3HubboAWgK4aqU"
    end

    def get_coordinate(location_name)
      result = {}
      request = request_json("https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name.gsub(' ','+')}+&key=#{apikey}")

      result[:lat] = request["results"][0]["geometry"]["location"]["lat"]
      result[:lng] = request["results"][0]["geometry"]["location"]["lng"]
      result
    end
end
