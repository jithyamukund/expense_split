# frozen_string_literal: true

# Migration to add index to the users attributes.
class AddUniqueIndexToUsersPhoneAndEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :phone_number, unique: true
    add_index :users, :email, unique: true
  end
end
