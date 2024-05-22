# frozen_string_literal: true

# Represents an Expense in the application.
class Expense < ApplicationRecord
  belongs_to :group
  has_many :expense_payers, dependent: :destroy
  accepts_nested_attributes_for :expense_payers

  validates :group_id, :description, :total_amount, :split_type_id, :date, presence: true
  validate :at_least_one_expense_payer
  validate :valid_split_type_id

  private

  def at_least_one_expense_payer
    errors.add(:base, 'must have at least one payer') if expense_payers.empty?
  end

  def valid_split_type_id
    errors.add(:split_type_id, 'Invalid SplitType') unless split_type_id.blank? || SplitType.exists?(split_type_id)
  end
end
