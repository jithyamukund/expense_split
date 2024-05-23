# frozen_string_literal: true

# split type for spliting amount in a group.
class SplitType < ApplicationRecord
  validates :type_name, presence: true
end
