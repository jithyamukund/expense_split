# frozen_string_literal: true

# Controller for managing expenses in the API version 1 namespace.
module Api
  module V1
    # Controller for managing expenses.
    class ExpensesController < ApplicationController
      before_action :set_group

      def index
        expenses = @group.expenses
        render json: expenses, status: :ok
      end

      def create
        service = ExpenseService.new(@group, expense_params, params[:payment_details])
        result = service.create_expense
        if result[:error]
          render json: { errors: result[:error] }, status: :unprocessable_entity
        else
          render json: { expense: ExpenseSerializer.new(result[:expense]) }, status: :created
        end
      end

      def update
        expense = @group.expenses.find_by(id: params[:id])
        if expense
          if expense.update(expense_params)
            render json: expense, status: :ok
          else
            render json: expense.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Expense not found' }, status: :not_found
        end
      end

      def destroy
        expense = @group.expenses.find_by(id: params[:id])
        if expense
          if expense.destroy
            render json: expense, status: :ok
          else
            render json: expense.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Expense not found' }, status: :not_found
        end
      end

      private

      def set_group
        @group = Group.find(params[:group_id])
      end

      def expense_params
        params.require(:expense).permit(:description, :total_amount, :split_type_id, :date, :group_id)
      end
    end
  end
end
