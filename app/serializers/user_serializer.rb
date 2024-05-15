# frozen_string_literal: true

# The UserSerializer class is responsible for serializing User objects
# into a JSON format that is suitable for API responses.
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phone_number
end
