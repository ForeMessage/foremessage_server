require 'faker'

FactoryBot.define do
  factory :user do
    nickname { 'TEST' }
    password { 'TEST1' }
    password_confirmation { 'TEST1' }
    phone_number { '010-1111-1111' }
    name { 'test' }
    birthday { Faker::Date.between(2.days.ago, Date.today) }
  end
end