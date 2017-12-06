require 'rails_helper'

RSpec.describe "drivers/index", type: :view do
  before(:each) do
    assign(:drivers, [
      Driver.create!(
        :username => "Username",
        :password => "Password",
        :full_name => "Full Name",
        :email => "Email",
        :phone => "Phone",
        :address => "MyText",
        :type => "Type",
        :credit => "9.99"
      ),
      Driver.create!(
        :username => "Username",
        :password => "Password",
        :full_name => "Full Name",
        :email => "Email",
        :phone => "Phone",
        :address => "MyText",
        :type => "Type",
        :credit => "9.99"
      )
    ])
  end

  it "renders a list of drivers" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Full Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
