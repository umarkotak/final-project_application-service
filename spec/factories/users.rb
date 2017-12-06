# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "MyString"
    password "MyString"
    full_name "MyString"
    email "MyString"
    phone "MyString"
    address "MyText"
    credit ""
  end
end
