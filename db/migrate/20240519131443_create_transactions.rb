# frozen_string_literal: true

# Migration to create ransactions table .
class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :group
      t.float :amount
      t.integer :paid_by
      t.integer :paid_to
      t.date :date

      t.timestamps
    end
  end
end
