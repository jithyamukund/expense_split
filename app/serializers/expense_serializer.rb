# frozen_string_literal: true

# The ExpenseSerializer class is responsible for serializing Expense objects
# into a JSON format that is suitable for API responses.
class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :description, :total_amount, :date

  has_many :expense_payers
  belongs_to :group
end
