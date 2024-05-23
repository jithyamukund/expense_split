# frozen_string_literal: true

# user_transaction.
class Transaction < ApplicationRecord
  belongs_to :group
end
