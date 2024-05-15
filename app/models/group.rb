# frozen_string_literal: true

# Represents a group in the application.
class Group < ApplicationRecord
  validates :name, presence: true
end
