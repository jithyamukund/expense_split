# frozen_string_literal: true

# The GroupSerializer class is responsible for serializing Group objects
# into a JSON format that is suitable for API responses.
class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
end
