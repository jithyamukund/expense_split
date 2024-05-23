# frozen_string_literal: true

def generate_first_name_with_min_length(min_length)
  loop do
    name = Faker::Name.first_name
    break name if name.length >= min_length
  end
end

FactoryBot.define do
  factory :user do
    transient do
      min_first_name_length { 3 } #default minimum length
    end

    first_name { generate_first_name_with_min_length(min_first_name_length) }
    last_name { Faker::Name.last_name.gsub(/[^a-zA-Z]/, '') }
    email { Faker::Internet.email }
    phone_number { Faker::Base.regexify(/[0-9]{10}/) }
    password { Faker::Internet.password(6, 20) }
  end
end
