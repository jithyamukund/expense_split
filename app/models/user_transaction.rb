# frozen_string_literal: true

# user_transaction.
class UserTransaction < ApplicationRecord
  belongs_to :group
end
