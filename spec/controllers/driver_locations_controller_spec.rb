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
    it "produce a message to allocation service" do
      
    end

    it "redirect to driver locations path" do
      post :create, params: { driver_location: attributes_for(:driver_location, driver: @driver) }
      expect(response).to redirect_to(driver_locations_path)
    end
  end
end
