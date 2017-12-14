class DriverLocationsController < ApplicationController
  before_action :set_driver_location, only: [:create]

  def index
    @driver = Driver.find(session[:driver_id])
    @driver_locations = DriverLocation.all
  end

  def new
    @driver = Driver.find(session[:driver_id])
    @driver_location = DriverLocation.new
  end

  def create
    @driver_location.destroy if @driver_location

    @driver_location = DriverLocation.new(driver_location_params)
    @driver = Driver.find(session[:driver_id])
    @driver_location.service_type = @driver.service_type

    begin
      @driver_location.get_coordinate(@driver_location.location)
    rescue
    end

    respond_to do |format|
      if @driver_location.save
        format.html { redirect_to driver_locations_path, notice: 'Driver was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @driver_location = DriverLocation.find(params[:id])
    @driver_location.destroy
    respond_to do |format|
      format.html { redirect_to driver_locations_url, notice: 'driver location was successfully destroyed.' }
    end
  end

  private
    def set_driver_location
      @driver_location = DriverLocation.find_by(driver_id: session[:driver_id])
    end

    def driver_location_params
      params.require(:driver_location).permit(:driver_id, :location, :lat, :lng, :status)
    end
end
