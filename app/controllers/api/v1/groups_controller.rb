# frozen_string_literal: true

# Controller for managing groups in the API version 1 namespace.
module Api
  module V1
    # Controller for managing groups.
    class GroupsController < ApplicationController
      def show
        group = Group.find(params[:id])
        render json: group
      end

      def create
        group = Group.new(group_params)
        if group.save
          render json: group, status: :created
        else
          render json: group.errors, status: :unprocessable_entity
        end
      end

      def update
        group = Group.find(params[:id])
        if group.update(group_params)
          render json: group, status: :ok
        else
          render json: group.errors, status: :unprocessable_entity
        end
      end

      def destroy
        group = Group.find(params[:id])
        if group.destroy
          render json: group, status: :ok
        else
          render json: group.errors, status: :unprocessable_entity
        end
      end

      private

      def group_params
        params.require(:group).permit(:name, :description)
      end
    end
  end
end
