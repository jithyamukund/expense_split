# frozen_string_literal: true

# Migration to create the groups table.
class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
