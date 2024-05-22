# frozen_string_literal: true

# The ExpensePayerSerializer class is responsible for serializing ExpensePayer objects
# into a JSON format that is suitable for API responses.
class ExpensePayerSerializer < ActiveModel::Serializer
  attributes :id, :amount, :date

  belongs_to :user
end
