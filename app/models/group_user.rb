# frozen_string_literal: true

# Represents a user in the application.
class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :user_id, uniqueness: { scope: :group_id }
end
