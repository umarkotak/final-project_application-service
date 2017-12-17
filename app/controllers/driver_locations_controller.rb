class DriverLocationsController < ApplicationController
  before_action :initiate_kafka, only: [:create, :destroy]
  before_action :set_driver_location, only: [:create, :micro_create]

  def index
    request = request_json("http://localhost:3001/driver_locations")
    @driver_locations = request.sort_by{ |hash| hash['driver_id'].to_i }
  end

  def new
    @driver = Driver.find(session[:driver_id])
    @driver_location = DriverLocation.new
  end

  def create
    @message[:action] = 'set_driver_location'

    @driver_location = DriverLocation.new(driver_location_params)
    @driver = Driver.find(session[:driver_id])
    @driver_location.service_type = @driver.service_type

    begin
      @driver_location.get_coordinate(@driver_location.location)
      @message[:driver_location] = {
        driver_id: session[:driver_id],
        service_type: @driver_location.service_type,
        location: @driver_location.location,
        lat: @driver_location.lat,
        lng: @driver_location.lng,
        status: @driver_location.status
      }
    rescue
    end

    respond_to do |format|
      if @driver_location.valid?
        @kafka.deliver_message("#{@message}", topic: 'driver_location')
        format.html { redirect_to driver_locations_path, notice: 'Driver was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @message[:action] = 'unset_driver_location'
    @message[:driver_id] = params[:id]
    @kafka.deliver_message("#{@message}", topic: 'driver_location')

    redirect_to driver_locations_url, notice: 'driver location was successfully unsetted.'
  end

  private
    def set_driver_location
      @driver_location = DriverLocation.find_by(driver_id: session[:driver_id])
    end

    def driver_location_params
      params.require(:driver_location).permit(:driver_id, :location, :lat, :lng, :status)
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
end
