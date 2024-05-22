require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    let(:group) { create(:group) }
    let(:split_type) { create(:split_type) }

    let(:expense_1)  { build(:expense, group: group, split_type_id: split_type.id ) }
    let(:expense_2)  { build(:expense, group: nil, total_amount: nil, split_type_id: nil) }

    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:total_amount)}
    it { should validate_presence_of(:split_type_id)}
    it { should validate_presence_of(:date)}

    it 'is valid with valid attributes' do
      expect(expense_1.valid?).to eq(true)
    end

    it 'is invalid with invalid attributes' do
      expect(expense_2.valid?).to eq(false)
    end
  end

  describe 'associations' do
    it { should have_many(:expense_payers) }
    it { should belong_to(:group)}
  end
end
