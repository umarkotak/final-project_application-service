require 'rails_helper'

RSpec.describe DriverLocationsController, type: :controller do
  before :each do
    @driver = create(:driver)
    session[:driver_id] = @driver.id
  end

  describe "GET #index" do
    it "will show all drivers location data" do
      driver1 = create(:driver, username: 'driverr1')
      driver_location1 = create(:driver_location, driver: @driver)
      driver_location2 = create(:driver_location, driver: driver1)
      get :index
      expect(assigns(:driver_locations)).not_to be_empty
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

  describe "POST #create" do
    it "produce a message with action set_driver_location" do
      post :create, params: { driver_location: attributes_for(:driver_location, driver_id: @driver.id, location: 'jakarta') }
      expect(assigns(:message)[:action]).to eq('set_driver_location')
    end

    it "produce a message to allocation service" do
      post :create, params: { driver_location: attributes_for(:driver_location, driver_id: @driver.id, location: 'jakarta') }
      expect(assigns(:message)[:driver_location][:driver_id]).to eq(@driver.id)
    end

    it "redirect to driver locations path" do
      post :create, params: { driver_location: attributes_for(:driver_location, driver_id: @driver.id, location: 'jakarta') }
      expect(response).to redirect_to(driver_locations_path)
    end
  end

  describe "DELETE #destroy" do
    it "produce a message with action unset_driver_location" do
      delete :destroy, params: { id: @driver.id }
      expect(assigns(:message)[:action]).to eq('unset_driver_location')
    end

    it "redirect to driver locations path" do
      delete :destroy, params: { id: @driver.id }
      expect(response).to redirect_to(driver_locations_path)
    end
  end
end
