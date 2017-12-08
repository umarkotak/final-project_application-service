require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without username" do
    user = build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include("can't be blank")
  end

  it "is invalid with duplicate username" do
    user1 = create(:user, username: "user")
    user2 = build(:user, username: "user")
    user2.valid?
    expect(user2.errors[:username]).to include("has already been taken")
  end

  it "is invalid without password" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is invalid with password length < 4 characters" do
    user = build(:user, password: "123")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 4 characters)")
  end

  it "is invalid with wrong password confirmation" do
    user = build(:user, password: "password", password_confirmation: "other_password")
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it "is invalid without full name" do
    user = build(:user, full_name: nil)
    user.valid?
    expect(user.errors[:full_name]).to include("can't be blank")
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with wrong email format" do
    user = build(:user, email: "wrongEmail")
    user.valid?
    expect(user.errors[:email]).to include("email format is invalid")
  end

  it "is invalid without a phone number" do
    user = build(:user, phone: nil)
    user.valid?
    expect(user.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with wrong phone format" do
    user = build(:user, phone: "wrongNumber")
    user.valid?
    expect(user.errors[:phone]).to include("is not a number")
  end

end
