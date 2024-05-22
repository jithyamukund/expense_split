# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    description { "food" }
    total_amount { 900 }
    date { Date.today }
    association :group
  end

end
