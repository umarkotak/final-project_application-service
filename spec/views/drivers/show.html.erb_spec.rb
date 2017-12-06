require 'rails_helper'

RSpec.describe "drivers/show", type: :view do
  before(:each) do
    @driver = assign(:driver, Driver.create!(
      :username => "Username",
      :password => "Password",
      :full_name => "Full Name",
      :email => "Email",
      :phone => "Phone",
      :address => "MyText",
      :type => "Type",
      :credit => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Full Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/9.99/)
  end
end
