# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user)  { build :user }

    it { should validate_length_of(:first_name).is_at_least(3).is_at_most(25) }
    it { should validate_length_of(:last_name).is_at_least(3).is_at_most(25) }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(20) }

    it { should validate_presence_of(:phone_number).with_message('can not be blank')}
    it { should validate_presence_of(:email).with_message('can not be blank')}
    it { should validate_uniqueness_of(:phone_number).with_message('has already been taken') }
    it { should validate_uniqueness_of(:email).with_message('has already been taken') }

    it { should allow_value('Joh').for(:first_name) }
    it { should_not allow_value('Joe123').for(:first_name).with_message('only letters are allowed') }
    it { should allow_value('Joh').for(:last_name) }
    it { should_not allow_value('Joe123').for(:last_name).with_message('only letters are allowed') }
    it { should allow_value('1234567890').for(:phone_number) }
    it { should_not allow_value('123456789').for(:phone_number).with_message('must be a valid 10-digit number') }
    it { should_not allow_value('12-3456789').for(:phone_number).with_message('must be a valid 10-digit number') }
    it { should_not allow_value('12a3456789').for(:phone_number).with_message('must be a valid 10-digit number') }
    it { should allow_value('email@gmail.com').for(:email) }
    it { should_not allow_value('email.gmail').for(:email).with_message('is invalid') }

    it 'is valid with valid attributes' do
      expect(user.valid?).to eq(true)
    end
  end
end