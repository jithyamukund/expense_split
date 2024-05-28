# frozen_string_literal: true

# Controller for managing expenses in the API version 1 namespace.
module Api
  module V1
    # Controller for managing expenses.
    class ExpensesController < ApplicationController
      before_action :set_group
      PER_PAGE = 10
      def index
        expenses = @group.expenses.includes(:expense_payers).page(params[:page]).per(PER_PAGE)
        render json: expenses, status: :ok
      end

      def create
        service = ExpenseService.new(@group, expense_params)
        result = service.create_expense
        if result[:errors]
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        else
          render json: result[:expense], status: :created
        end
      end

      private

      def set_group
        @group = Group.find_by(id: params[:group_id])
      end

      def expense_params
        params.require(:expense).permit(:description, :total_amount, :split_type_id, :date, :group_id,
                                        expense_payers_attributes: %i[amount paid_by date])
      end
    end
  end
end


