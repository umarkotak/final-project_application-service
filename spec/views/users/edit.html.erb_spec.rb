require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :username => "MyString",
      :password => "MyString",
      :full_name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :address => "MyText",
      :credit => ""
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[username]"

      assert_select "input[name=?]", "user[password]"

      assert_select "input[name=?]", "user[full_name]"

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[phone]"

      assert_select "textarea[name=?]", "user[address]"

      assert_select "input[name=?]", "user[credit]"
    end
  end
end
