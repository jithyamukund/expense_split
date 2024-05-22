# frozen_string_literal: true

class CustomError < StandardError
end

# creating expense, expense payers
class ExpenseService
  attr_accessor :expense, :group, :expense_params, :payment_details

  def initialize(group, expense_params, payment_details)
    @group = group
    @expense_params = expense_params
    @payment_details = payment_details
  end

  def create_expense
    result = {}
    expense = group.expenses.new(expense_params)

    if expense.save
      process_payment_details(expense)
      result[:expense] = expense
    else
      result[:error] = expense.errors.full_messages
    end
    result
  rescue CustomError => e
    expense.destroy if expense.persisted?
    result[:error] = e.message
    result
  end

  private

  def process_payment_details(expense)
    validate_payment_details_presence
    validate_split_type

    payment_details.each do |payer|
      user = User.find_by(id: payer[:user_id])
      raise CustomError, "User with ID #{payer[:user_id]} not found." unless user

      expense_payer = expense.expense_payers.new(user: user, amount: payer[:paid_amount], date: expense.date)
      raise CustomError, 'Failed to save expense payer.' unless expense_payer.save
    end

    true
  end

  def validate_payment_details_presence
    raise CustomError, 'Payment details cannot be blank.' if payment_details.blank?
  end

  def validate_split_type
    type = SplitType.find_by(id: expense_params[:split_type_id])
    raise CustomError, 'Invalid split type.' if type.nil?
  end
end
