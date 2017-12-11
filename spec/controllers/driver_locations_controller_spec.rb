require 'rails_helper'

RSpec.describe DriverLocationsController, type: :controller do
  before :each do
    @driver = create(:driver)
    session[:driver_id] = @driver.id
  end

  
end
