# frozen_string_literal: true

# Migration to add unique index table .
class AddUniqueIndexToGroupUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :group_users, %i[user_id group_id], unique: true
  end
end
