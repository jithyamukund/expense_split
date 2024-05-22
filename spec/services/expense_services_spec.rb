require 'rails_helper'

RSpec.describe ExpenseService, type: :service do

  let(:group) { create(:group) }
  let(:split_type) { create(:split_type) }
  let(:user) { create(:user) }
  let(:expense_payers_attributes) { [{ paid_by: user.id, amount: 1000, date: Date.today }] }
  let(:expense_params) { attributes_for(:expense).merge(split_type_id: split_type.id,
                                                        expense_payers_attributes: expense_payers_attributes) }

  describe '#create_expense' do
    context 'with valid expense params' do
      it 'creates a new expense' do
        service = ExpenseService.new(group, expense_params)
        result = service.create_expense

        expect(result[:expense]).to be_a(Expense)
        expect(result[:expense]).to be_persisted
        expect(result[:errors]).to be_nil
      end
    end

    context 'with invalid expense params' do
      it 'does not create a new expense' do
        invalid_expense_params = expense_params.merge(description: nil)

        service = ExpenseService.new(group, invalid_expense_params)
        result = service.create_expense

        expect(result[:expense]).to be_nil
        expect(result[:errors]).to include("Description can't be blank")
      end
    end
  end
end
