# frozen_string_literal: true

# Represents a user in the application.
class User < ApplicationRecord
  has_secure_password
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :expense_payers, foreign_key: :paid_by, dependent: :destroy, inverse_of: :user

  validates :first_name,
            presence: true,
            length: { minimum: 3, maximum: 25 },
            format: {
              with: /\A[a-zA-Z]+\z/,
              message: I18n.t('only_letters_are_allowed')
            }
  validates :last_name,
            presence: true,
            length: { minimum: 3, maximum: 25 },
            format: {
              with: /\A[a-zA-Z]+\z/,
              message: I18n.t('only_letters_are_allowed')
            }
  validates :phone_number,
            uniqueness: { message: I18n.t('has_already_been_taken') },
            presence: { message: I18n.t('can_not_be_blank') },
            format: {
              with: /\A[0-9]{10}\z/,
              message: I18n.t('must_be_a_valid_10_digit_number')
            }
  validates :email,
            uniqueness: { message: I18n.t('has_already_been_taken') },
            presence: { message: I18n.t('can_not_be_blank') },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: I18n.t('is_invalid')
            }
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 20 },
            on: :create

  before_save do
    self.email = email.downcase.strip if email.present?
  end
end
