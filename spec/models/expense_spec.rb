require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    let(:group) { create(:group) }
    let(:split_type) { create(:split_type) }
    let(:user) { create(:user) }
    let(:expense_payers_attributes) { [{ paid_by: user.id, amount: 1000, date: Date.today }] }
    let(:expense_1) do
      build(:expense,
            group: group,
            split_type_id: split_type.id,
            expense_payers_attributes: expense_payers_attributes
      )
    end
    let(:expense_2)  { build(:expense, date: '') }

    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:total_amount)}
    it { should validate_presence_of(:split_type_id)}
    it { should validate_presence_of(:date)}

    it 'is valid with valid attributes' do
      expect(expense_1).to be_valid
    end

    it 'is invalid with invalid attributes' do
      expect(expense_2).not_to be_valid
    end

    it 'validates presence of at least one expense payer' do
      expense = Expense.new
      expense.validate
      expect(expense.errors[:base]).to include('must have at least one payer')
    end

    it 'validates the presence of a valid split type' do
      expense = Expense.new(split_type_id: 'invalid_id')
      expense.validate
      expect(expense.errors[:split_type_id]).to include('Invalid SplitType')
    end
  end

  describe 'associations' do
    it { should have_many(:expense_payers).dependent(:destroy) }
    it { should accept_nested_attributes_for(:expense_payers) }
    it { should belong_to(:group)}
  end
end
