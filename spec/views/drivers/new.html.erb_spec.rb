require 'rails_helper'

RSpec.describe "drivers/new", type: :view do
  before(:each) do
    assign(:driver, Driver.new(
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

  it "renders new driver form" do
    render

    assert_select "form[action=?][method=?]", drivers_path, "post" do

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
