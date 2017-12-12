class UsersController < ApplicationController
  skip_before_action :authorize, only:[:create, :new]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :set_topup]
  before_action :authenticate, only: [:show, :edit]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @order_histories = Order.where(user_id: session[:user_id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
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
    def set_user
      @user = User.find(params[:id])
    end  

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :full_name, :email, :phone, :address, :credit, :topup_amount)
    end

    # current user cannot access another user profile
    def authenticate
      if session[:user_id]
        redirect_to user_path(session[:user_id]) if @user.id != session[:user_id]
      elsif session[:driver_id]
        redirect_to driver_path(session[:driver_id])
      end
    end
end
