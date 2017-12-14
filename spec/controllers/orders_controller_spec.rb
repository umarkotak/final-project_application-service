require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before :each do
    @driver = create(:driver)
    @user = create(:user)
    session[:driver_id] = @driver.id
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "populates an array of orders" do
      order1 = create(:order, user: @user, driver: @driver)
      order2 = create(:order, user: @user, driver: @driver)

      get :index
      expect(assigns(:orders)).to eq(Order.all.order(id: :desc))
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #confirm_order" do
    it "show the location confirmation" do
      
    end

    it "renders the :confirm_order template" do
      
    end
  end

  describe "POST #create" do
    
  end

  describe "DELETE #destroy" do
    
  end
end
