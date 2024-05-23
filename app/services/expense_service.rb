# frozen_string_literal: true

# creating expense, expense payers
class ExpenseService
  attr_accessor :expense, :group, :expense_params

  def initialize(group, expense_params)
    @group = group
    @expense_params = expense_params
  end

  def create_expense
    result = {}
    expense = group.expenses.new(expense_params)
    if expense.save
      result[:expense] = expense
    else
      result[:errors] = expense.errors.full_messages
    end
    result
  end
end
