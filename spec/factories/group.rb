# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
  end
end
