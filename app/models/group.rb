# frozen_string_literal: true

# Represents a group in the application.
class Group < ApplicationRecord
  validates :name, presence: true
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  def add_user(user)
    return if users.include?(user)

    users << user
  end
end
