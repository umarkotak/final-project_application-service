require 'rails_helper'

RSpec.describe DriverLocation, type: :model do
  it "has a valid factory" do
    expect(build(:driver_location)).to be_valid
  end

  describe "attributes validation" do
    it "is invalid without driver" do
      driver_location = build(:driver_location, driver_id: nil)
      driver_location.valid?
      expect(driver_location.errors[:driver_id]).to include("can't be blank")
    end

    it "is invalid without location" do
      driver_location = build(:driver_location, location: nil)
      driver_location.valid?
      expect(driver_location.errors[:location]).to include("can't be blank")
    end

    it "is invalid with unavailable location" do
      driver_location = build(:driver_location, location: 'errorloc')
      driver_location.valid?
      expect(driver_location.errors[:location]).to include("is invalid")
    end

    it "is invalid without lat" do
      driver_location = build(:driver_location, lat: nil)
      driver_location.valid?
      expect(driver_location.errors[:lat]).to include("can't be blank")
    end

    it "is invalid without lng" do
      driver_location = build(:driver_location, lng: nil)
      driver_location.valid?
      expect(driver_location.errors[:lng]).to include("can't be blank")
    end

    it "is invalid without status" do
      driver_location = build(:driver_location, status: nil)
      driver_location.valid?
      expect(driver_location.errors[:status]).to include("can't be blank")
    end

    it "is invalid with wrong status" do
      driver_location = build(:driver_location, status: 'sakit')
      driver_location.valid?
      expect(driver_location.errors[:status]).to include("sakit is not a valid status type")
    end
  end

  describe "method validation" do
    before :each do
      @driver_location = create(:driver_location)
    end

    it "have an API key" do
      expect(@driver_location.apikey).not_to be_empty
    end

    context "create coordinate form location" do
      it "will assign lat to driver_location" do
        @driver_location.get_coordinate('jakarta')
        expect(@driver_location.lat).to eq(-6.17511)
      end

      it "will assign lng to driver_location" do
        @driver_location.get_coordinate('jakarta')
        expect(@driver_location.lng).to eq(106.8650395)
      end
    end

    
  end

end
