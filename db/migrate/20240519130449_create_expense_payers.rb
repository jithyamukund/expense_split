# frozen_string_literal: true

# Migration to create expense_payers table .
class CreateExpensePayers < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_payers do |t|
      t.references :expense, foreign_key: true
      t.float :amount
      t.integer :paid_by
      t.datetime :date

      t.timestamps
    end
  end
end
