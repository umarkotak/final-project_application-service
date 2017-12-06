require 'rails_helper'

RSpec.describe "drivers/edit", type: :view do
  before(:each) do
    @driver = assign(:driver, Driver.create!(
      :username => "MyString",
      :password => "MyString",
      :full_name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :address => "MyText",
      :type => "",
      :credit => "9.99"
    ))
  end

  it "renders the edit driver form" do
    render

    assert_select "form[action=?][method=?]", driver_path(@driver), "post" do

      assert_select "input[name=?]", "driver[username]"

      assert_select "input[name=?]", "driver[password]"

      assert_select "input[name=?]", "driver[full_name]"

      assert_select "input[name=?]", "driver[email]"

      assert_select "input[name=?]", "driver[phone]"

      assert_select "textarea[name=?]", "driver[address]"

      assert_select "input[name=?]", "driver[type]"

      assert_select "input[name=?]", "driver[credit]"
    end
  end
end
