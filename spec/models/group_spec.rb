require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    let(:group)  { Group.new(name: 'NewGroup_1') }
    it { should validate_presence_of(:name).with_message("can't be blank")}

    it 'is valid with valid attributes' do
      expect(group.valid?).to eq(true)
    end
  end
end
