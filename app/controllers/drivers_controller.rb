class DriversController < ApplicationController
  skip_before_action :authorize, only:[:create, :new]
  before_action :set_driver, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:show, :edit]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
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

  # DELETE /drivers/1
  # DELETE /drivers/1.json
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
    res = @user.topup(params[:topup_amount])
    
    respond_to do |format|
      if @user.save && res
        format.html { redirect_to topup_user_path, notice: 'Top up success.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to topup_user_path, notice: 'Top up failed: amount is invalid' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:username, :password, :full_name, :email, :phone, :address, :service_type, :credit)
    end

    # current driver cannot access another driver profile
    def authenticate
      if session[:driver_id]
        redirect_to driver_path(session[:driver_id]) if @driver.id != session[:driver_id]
      elsif session[:driver_id]
        redirect_to user_path(session[:user_id])
      end
    end
end
