class UsersController < ApplicationController
  skip_before_action :authorize, only:[:create, :new]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :set_topup]
  before_action :authenticate, only: [:show, :edit]

  def index
    @users = User.all
  end

  def show
    @order_histories = Order.where(user_id: session[:user_id]).order(id: :desc)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  def topup
  end

  def set_topup
    res = @user.topup(params[:topup_amount])
    
    respond_to do |format|
      if @user.save && res
        format.html { redirect_to topup_user_path, notice: 'Top up success.' }
      else
        format.html { redirect_to topup_user_path, notice: 'Top up failed: amount is invalid' }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end  

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :full_name, :email, :phone, :address, :credit, :topup_amount)
    end

    def authenticate
      if session[:user_id]
        redirect_to user_path(session[:user_id]) if @user.id != session[:user_id]
      elsif session[:driver_id]
        redirect_to driver_path(session[:driver_id])
      end
    end
end
