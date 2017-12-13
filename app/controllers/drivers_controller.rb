class DriversController < ApplicationController
  skip_before_action :authorize, only:[:create, :new]
  before_action :set_driver, only: [:show, :edit, :update, :destroy, :topup, :set_topup]
  before_action :authenticate, only: [:show, :edit]

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
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def topup
  end

  def set_topup
    res = @driver.topup(params[:topup_amount])
    
    respond_to do |format|
      if @driver.save && res
        format.html { redirect_to topup_driver_path, notice: 'Top up success.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { redirect_to topup_driver_path, notice: 'Top up failed: amount is invalid' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def job
    @driver_location = DriverLocation.find_by(driver_id: session[:driver_id])
    @order = Order.find_by(id: @driver_location.try(:order_id))

    @finished_orders = Order.where(driver_id: session[:driver_id]).order(id: :desc)
  end

  def do_job
    @driver_location = DriverLocation.find_by(driver_id: session[:driver_id])
    
    @order = Order.find_by(id: @driver_location.order_id)
    @order.status = params[:status]

    Driver.complete_job(@order) if @order.status == 'completed'

    @driver_location.order_id = nil
    @driver_location.status = 'online'

    respond_to do |format|
      if @driver_location.save && @order.save
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
end
