# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    username "MyString"
    password "MyString"
    full_name "MyString"
    email "MyString"
    phone "MyString"
    address "MyText"
    type ""
    credit "9.99"
  end
end
