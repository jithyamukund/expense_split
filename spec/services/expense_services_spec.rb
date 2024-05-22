require 'rails_helper'

RSpec.describe ExpenseService, type: :service do

  let(:group) { create(:group) }
  let(:split_type) { create(:split_type) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:expense_params) { { total_amount: 200, description: 'Test expense', split_type_id: split_type.id, date: Date.today } }
  let(:invalid_expense_params) { { total_amount: nil, description: 'Test expense', split_type_id: split_type.id, date: Date.today } }
  let(:payment_details) { [{ user_id: user1.id, paid_amount: 100 }, { user_id: user2.id, paid_amount: 200 }] }
  let(:service) { described_class.new(group, expense_params, payment_details) }
  let(:invalid_service) { described_class.new(group, invalid_expense_params, payment_details) }

  describe '#create_expense' do
    context 'when expense is successfully created' do
      it 'returns the created expense' do
        result = service.create_expense
        expect(result[:expense]).to be_persisted
        expect(result[:error]).to be_nil
      end
    end

    context 'when expense fails to save' do
      before do
        allow_any_instance_of(Expense).to receive(:save).and_return(false)
      end

      it 'returns an error message' do
        result = invalid_service.create_expense
        expect(result[:expense]).to be_nil
        expect(result[:error]).not_to be_nil
      end
    end

    context 'when a CustomError is raised' do
      before { allow(service).to receive(:process_payment_details).and_raise(CustomError, 'Custom error message') }

      it 'destroys the expense and returns the error message' do
        result = service.create_expense
        expect(result[:expense]).to be_nil
        expect(result[:error]).to eq('Custom error message')
      end
    end
  end

  describe '#process_payment_details' do
    context 'when payment details are valid' do
      it 'processes payment details successfully' do
        expense = create(:expense, group: group, **expense_params)
        expect { service.send(:process_payment_details, expense) }.not_to raise_error
      end
    end

    context 'when payment details are missing' do
      let(:payment_details) { [] }

      it 'raises a CustomError' do
        expense = create(:expense, group: group, **expense_params)
        expect { service.send(:process_payment_details, expense) }.to raise_error(CustomError, 'Payment details cannot be blank.')
      end
    end

    context 'when split type is invalid' do
      let(:expense_params) { { total_amount: 100, description: 'Test expense', split_type_id: 'TEST', date: Date.today } }

      it 'raises a CustomError' do
        expense = create(:expense, group: group, **expense_params)
        expect { service.send(:process_payment_details, expense) }.to raise_error(CustomError, 'Invalid split type.')
      end
    end

    context 'when a user in payment details is not found' do
      let(:payment_details) { [{ user_id: 'TEST', paid_amount: 100 }] }

      it 'raises a CustomError' do
        expense = create(:expense, group: group, **expense_params)
        expect { service.send(:process_payment_details, expense) }.to raise_error(CustomError, /User with ID TEST not found/)
      end
    end
  end
end
