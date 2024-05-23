require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    let(:group)  { build :group }

    it { should validate_presence_of(:name).with_message("can't be blank")}
    it 'is valid with valid attributes' do
      expect(group.valid?).to eq(true)
    end
  end

  describe 'associations' do
    it { should have_many(:group_users) }
    it { should have_many(:users).through(:group_users) }
  end
end
