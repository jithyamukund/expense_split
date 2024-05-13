# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone_number { Faker::Base.regexify(/[0-9]{10}/) }
    password { Faker::Internet.password(6, 15) }
  end
end
