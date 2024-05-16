# frozen_string_literal: true

# Represents a user in the application.
class User < ApplicationRecord
  has_secure_password
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  validates :first_name,
            presence: true,
            length: { minimum: 3, maximum: 25 },
            format: {
              with: /\A[a-zA-Z]+\z/,
              message: 'only letters are allowed'
            }
  validates :last_name,
            presence: true,
            length: { minimum: 3, maximum: 25 },
            format: {
              with: /\A[a-zA-Z]+\z/,
              message: 'only letters are allowed'
            }
  validates :phone_number,
            uniqueness: { message: 'has already been taken' },
            presence: { message: 'can not be blank' },
            format: {
              with: /\A[0-9]{10}\z/,
              message: 'must be a valid 10-digit number'
            }
  validates :email,
            uniqueness: { message: 'has already been taken' },
            presence: { message: 'can not be blank' },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: 'is invalid'
            }
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 20 },
            on: :create

  before_save do
    self.email = email.downcase.strip if email.present?
  end
end
