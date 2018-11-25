require 'faker'

FactoryBot.define do
  factory :user do
    phone_number { '01011111111' }
    device_id { 'test_device_1' }
    name { 'test' }
    birthday { Faker::Date.between(2.days.ago, Date.today) }
  end
end
