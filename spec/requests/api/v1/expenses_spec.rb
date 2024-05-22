require 'rails_helper'

RSpec.describe Api::V1::ExpensesController, type: :controller do

  let(:group) { create(:group) }
  let(:split_type) { create(:split_type) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:expense) { build(:expense, group: group, split_type_id: split_type.id) }
  let(:expense_params) { { total_amount: 200, description: 'Test expense', split_type_id: split_type.id, date: Date.today } }
  let(:payment_details) { [{ user_id: user1.id, paid_amount: 100 }, { user_id: user2.id, paid_amount: 200 }] }

  before do
    allow(Group).to receive(:find).and_return(group)
    allow(group).to receive(:expenses).and_return(Expense)
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        group_id: group.id,
        expense: expense_params,
        payment_details: payment_details
      }
    end

    context 'when expense is successfully created' do
      before do
        expense.save
        allow_any_instance_of(ExpenseService).to receive(:create_expense).and_return(service_result)
      end
      let(:service_result) { { expense: expense } }

      it 'returns a created status and the expense details' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('expense')
      end
    end

    context 'when there is an error creating the expense' do
      let(:service_result) { { error: ['Some error'] } }
      before do
        allow_any_instance_of(ExpenseService).to receive(:create_expense).and_return(service_result)
      end

      it 'returns an unprocessable entity status and the error message' do
        post :create, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors' => ['Some error'])
      end
    end
  end

end
