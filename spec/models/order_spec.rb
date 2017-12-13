require 'rails_helper'

RSpec.describe Order, type: :model do
  it "has valid factory" do
    expect(build(:order)).to be_valid
  end

  describe "attributes validation" do
    it "is invalid without user_id" do
      order = build(:order, user_id: nil)
      order.valid?
      expect(order.errors[:user_id]).to include("can't be blank")
    end

    it "is invalid without origin" do
      order = build(:order, origin: nil)
      order.valid?
      expect(order.errors[:origin]).to include("can't be blank")
    end

    it "is invalid without destination" do
      order = build(:order, destination: nil)
      order.valid?
      expect(order.errors[:destination]).to include("can't be blank")
    end

    it "is invalid without service_type" do
      order = build(:order, service_type: nil)
      order.valid?
      expect(order.errors[:service_type]).to include("can't be blank")
    end

    it "is invalid with wrong service_type" do
      order = build(:order, service_type: 'wrong')
      order.valid?
      expect(order.errors[:service_type]).to include('wrong is not a valid service type')
    end

    it "is invalid without payment_type" do
      order = build(:order, payment_type: nil)
      order.valid?
      expect(order.errors[:payment_type]).to include("can't be blank")
    end

    it "is invalid with wrong payment_type" do
      order = build(:order, payment_type: 'wrong')
      order.valid?
      expect(order.errors[:payment_type]).to include('wrong is not a valid payment type')
    end
  end

  describe "method validation" do
    before :each do
      @order = create(:order)
    end

    it "have an API key" do
      expect(@order.apikey).not_to be_empty
    end

    it "can get location coordinate" do
      coordinate = @order.get_coordinate('jakarta')
      expect(coordinate).to eq({lat: -6.17511, lng: 106.8650395})
    end

    describe "can validate availabilty between 2 routes" do
      it "with valid routes" do
        expect(@order.validate_route(@order.origin, @order.destination)).not_to be_empty
      end

      it "with invalid routes" do
        expect(@order.validate_route('invalid', '')).to eq(false)
      end
    end

    it "can calculate distance" do
      distance_matrix = @order.validate_route(@order.origin, @order.destination)
      @order.set_distance(distance_matrix)
      expect(@order.distance.to_f).to eq(20.04)
    end

    it "can calculate price" do
      distance_matrix = @order.validate_route(@order.origin, @order.destination)
      @order.set_distance(distance_matrix)
      @order.set_price
      expect(@order.price.to_f).to eq(30060.0)
    end

    it "can check if user gopay is sufficient" do
      user = create(:user, username: 'umarkotak')  
      @order.price = 65000
      expect(@order.check_gopay(user)).to eq(false)
    end
  end
end
