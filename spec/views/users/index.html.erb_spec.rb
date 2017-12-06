require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :username => "Username",
        :password => "Password",
        :full_name => "Full Name",
        :email => "Email",
        :phone => "Phone",
        :address => "MyText",
        :credit => ""
      ),
      User.create!(
        :username => "Username",
        :password => "Password",
        :full_name => "Full Name",
        :email => "Email",
        :phone => "Phone",
        :address => "MyText",
        :credit => ""
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Full Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
