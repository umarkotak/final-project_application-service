# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    association :user
    association :driver
    origin 'jakarta'
    destination 'kemang'
    service_type 'gojek'
    payment_type 'cash'
  end
end
