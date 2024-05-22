require 'rails_helper'

RSpec.describe Api::V1::ExpensesController, type: :controller do

  let(:group) { create(:group) }
  let(:split_type) { create(:split_type) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:expense_payers_attributes) do
    [
      { paid_by: user1.id, amount: 1000, date: Date.today },
      { paid_by: user2.id, amount: 200,  date: Date.today }
    ]
  end

  let(:expense_params) do
    attributes_for(:expense).merge(
      split_type_id: split_type.id,
      expense_payers_attributes: expense_payers_attributes
    )
  end

  let(:invalid_expense_params) do
    attributes_for(:expense).merge(
      date: '',
      split_type_id: split_type.id,
      expense_payers_attributes: expense_payers_attributes
    )
  end

  describe 'POST #create' do
    it 'creates a new expense' do
      expect {
        post :create, params: { group_id: group.id, expense: expense_params }
      }.to change(Expense, :count).by(1).and change(ExpensePayer, :count).by(2)
    end

    it 'returns a created status and the expense details' do
      post :create, params: { group_id: group.id, expense: expense_params }
      expect(response).to have_http_status(:created)
    end

    context 'with invalid params' do
      it 'does not create a new expense' do
        expect {
          post :create, params: { group_id: group.id, expense: invalid_expense_params }
        }.not_to change(Expense, :count)

        expect {
          post :create, params: { group_id: group.id, expense: invalid_expense_params }
        }.not_to change(ExpensePayer, :count)
      end

      it 'returns an unprocessable entity status and the error message' do
        post :create, params: { group_id: group.id, expense: invalid_expense_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
end
