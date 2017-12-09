require 'rails_helper'

RSpec.describe Driver, type: :model do
  it "has a valid factory" do
    expect(build(:driver)).to be_valid
  end

  describe "attributes validation" do
    it "is invalid without drivername" do
      driver = build(:driver, username: nil)
      driver.valid?
      expect(driver.errors[:username]).to include("can't be blank")
    end

    it "is invalid with duplicate drivername" do
      driver1 = create(:driver, username: "driver")
      driver2 = build(:driver, username: "driver")
      driver2.valid?
      expect(driver2.errors[:username]).to include("has already been taken")
    end

    it "is invalid without password" do
      driver = build(:driver, password: nil)
      driver.valid?
      expect(driver.errors[:password]).to include("can't be blank")
    end

    it "is invalid with password length < 4 characters" do
      driver = build(:driver, password: "123")
      driver.valid?
      expect(driver.errors[:password]).to include("is too short (minimum is 4 characters)")
    end

    it "is invalid with wrong password confirmation" do
      driver = build(:driver, password: "password", password_confirmation: "other_password")
      driver.valid?
      expect(driver.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "is invalid without full name" do
      driver = build(:driver, full_name: nil)
      driver.valid?
      expect(driver.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without email" do
      driver = build(:driver, email: nil)
      driver.valid?
      expect(driver.errors[:email]).to include("can't be blank")
    end

    it "is invalid with wrong email format" do
      driver = build(:driver, email: "wrongEmail")
      driver.valid?
      expect(driver.errors[:email]).to include("email format is invalid")
    end

    it "is invalid without a phone number" do
      driver = build(:driver, phone: nil)
      driver.valid?
      expect(driver.errors[:phone]).to include("can't be blank")
    end

    it "is invalid with wrong phone format" do
      driver = build(:driver, phone: "wrongNumber")
      driver.valid?
      expect(driver.errors[:phone]).to include("is not a number")
    end

    it "is invalid without service type" do
      driver = build(:driver, service_type: nil)
      driver.valid?
      expect(driver.errors[:service_type]).to include("can't be blank")
    end

    it "is invalid with service type other than gojek and gocar" do
      driver = build(:driver, service_type: "go")
      driver.valid?
      expect(driver.errors[:service_type]).to include("go is not a valid service type")
    end
  end

  describe "top up validation" do
    it "let the driver to topup their credit" do
      driver = create(:driver)
      driver.topup("5000")
      expect(driver.credit).to eq(55000)
    end

    it "will not let the driver to topup their credit with invalid value" do
      driver = create(:driver)
      driver.topup(nil)
      expect(driver.credit).to eq(50000)
    end
  end

end
