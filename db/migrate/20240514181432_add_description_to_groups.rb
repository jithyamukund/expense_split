# frozen_string_literal: true

# Migration to add description field to groups table.
class AddDescriptionToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :description, :text
  end
end
