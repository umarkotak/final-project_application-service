# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver_location do
    association :driver
    location "jakarta"
    lat -6.17511
    lng 106.8650395
    status "online"
  end
end
