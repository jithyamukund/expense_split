# frozen_string_literal: true

# Migration to create expenses table .
class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.references :group, foreign_key: true
      t.text :description
      t.float :total_amount
      t.integer :split_type_id
      t.datetime :date

      t.timestamps
    end
  end
end
