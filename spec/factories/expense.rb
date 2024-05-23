# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    description { Faker::Lorem.sentence }
    total_amount { 1200 }
    date { Date.today }
    association :group

    after(:build) do |expense|
      expense.expense_payers << build(:expense_payer, expense: expense)
      expense.expense_payers << build(:expense_payer, expense: expense)
    end
  end

  factory :expense_payer do
    amount { 100 }
    date { Date.today }
    association :user
    association :expense
  end
end
