require 'rails_helper'

RSpec.describe SplitType, type: :model do
  describe 'validations' do
    let(:split_type) { build :split_type }
    it { should validate_presence_of(:type_name).with_message("can't be blank")}

    it 'is valid with valid attributes' do
      expect(split_type.valid?).to eq(true)
    end
  end
end
