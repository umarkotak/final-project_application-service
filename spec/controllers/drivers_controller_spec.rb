require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  before :each do
    @driver = create(:driver)
    session[:driver_id] = @driver.id
  end

  describe "GET #index" do
    it "populates an array of all drivers" do
      driver1 = create(:driver, username: "umar1")
      driver2 = create(:driver, username: "umar2")
      
      get :index
      expect(assigns(:drivers)).to eq(Driver.all)
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested driver to @driver" do
      get :show, params: { id: @driver }
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :show template" do
      get :show, params: { id: @driver}
      expect(response).to render_template :show
    end

    it "redirect to @driver if driver try to show another driver" do
      driver1 = create(:driver, username: "driver200")
      get :show, params: { id: driver1 }
      expect(response).to redirect_to(@driver)
    end
  end

  describe "GET #new" do

  end

  describe "GET #edit" do
    it "assigns the requested driver to @driver" do
      get :edit, params: { id: @driver }
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :edit template" do
      get :edit, params: { id: @driver}
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    it "assigns 50000 credit to new users" do
      expect(@driver.credit).to eq 50000
    end

    it "saves the new driver in the database" do
      expect {
        post :create, params: { driver: attributes_for(:driver, username: 'umar1') }
      }.to change(Driver, :count).by(1)
    end

    it "is redirected to login page" do
      post :create, params: { driver: attributes_for(:driver, username: 'umar1') }
      expect(response).to redirect_to(login_driver_path)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "locates the requested driver" do

      end

      it "saves the new password" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @driver.reload
        expect(@driver.authenticate('newlongpassword')).to eq(@driver)
      end

      it "redirects to driver#index" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(response).to redirect_to(driver_path(assigns[:driver]))
      end

      it "disables login with old password" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword')}
        @driver.reload
        expect(@driver.authenticate('oldpassword')).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the driver in the database" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: nil, password_confirmation: nil) }
        @driver.reload
        expect(@driver.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, username: nil) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes driver from the database" do
      driver = create(:driver, username: 'umar1')
      expect{
        delete :destroy, params: { id: driver }
      }.to change(Driver, :count).by(-1)
    end
    it "redirects to driver#index" do
      delete :destroy, params: { id: @driver }
      expect(response).to redirect_to drivers_path
    end
  end

  describe "PATCH #set_topup" do
    context "with valid amount" do
      it "will add the value of credit with amount" do
        patch :set_topup, params: { id: @driver, topup_amount: 1.0 }
        @driver.reload
        expect(@driver.credit.to_f).to eq(50001.0)
      end

      it "redirects to top up page" do
        patch :set_topup, params: { id: @driver }
        expect(response).to redirect_to topup_driver_path
      end
    end

    context "with invalid amount" do
      it "will not add the value of credit" do
        patch :set_topup, params: { id: @driver, amount: "1a" }
        @driver.reload
        expect(@driver.credit.to_f).to eq(50000.0)
      end

      it "redirects to top up page" do
        patch :set_topup, params: { id: @driver }
        expect(response).to redirect_to topup_driver_path
      end
    end
  end

  describe "GET #job" do
    it "assign current job if exist" do
      order = create(:order, driver: @driver)
      driver_location = create(:driver_location, driver: @driver, order: order)
      get :job, params: { id: @driver }
      expect(assigns(:order)).to eq(order)
    end

    it "will populates jobs history" do
      order = create(:order, driver: @driver)
      get :job, params: { id: @driver }
      expect(assigns(:finished_orders)).to include(order)
    end

    it "renders the :job template" do
      get :job, params: { id: @driver}
      expect(response).to render_template :job
    end
  end

  describe "POST #do_job" do
    it "will execute the transaction if completed" do
      order = create(:order, driver: @driver, price: 5000, payment_type: 'gopay')
      post :do_job, params: { driver: @driver }
      @driver.reload
      expect(assigns(:driver).credit).to eq(55000)
    end

    it "will change the driver_location order_id to be nil" do
      
    end

    it "will change the driver_location status to be online" do
      
    end

    it "will complete the order" do
      
    end

    it "saves the new driver in the database" do
      expect {
        post :create, params: { driver: attributes_for(:driver, username: 'umar1') }
      }.to change(Driver, :count).by(1)
    end

    it "is redirected to login page" do
      post :create, params: { driver: attributes_for(:driver, username: 'umar1') }
      expect(response).to redirect_to(login_driver_path)
    end
  end
end
