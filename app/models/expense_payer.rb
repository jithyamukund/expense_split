# frozen_string_literal: true

# expense_payer
class ExpensePayer < ApplicationRecord
  belongs_to :expense
  belongs_to :user, foreign_key: :paid_by, inverse_of: :expense_payers
  validates  :paid_by, :amount, :date, presence: true
end
