# frozen_string_literal: true

# Represents an Expense in the application.
class Expense < ApplicationRecord
  belongs_to :group
  has_many :expense_payers, dependent: :destroy

  validates :group_id, :description, :total_amount, :split_type_id, :date, presence: true
end
