# frozen_string_literal: true

# Migration to create user_transactions table .
class CreateUserTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_transactions do |t|
      t.references :group
      t.float :amount
      t.integer :paid_by
      t.integer :paid_to
      t.date :date

      t.timestamps
    end
  end
end
