# frozen_string_literal: true

# Controller for managing groups in the API version 1 namespace.
module Api
  module V1
    # Controller for managing groups.
    class GroupsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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

      def add_members
        group = Group.find(params[:id])
        user = User.find(params[:user_id])
        if group && user
          group.users << user
          render json: group.users, status: :ok
        else
          render json: { error: 'Group or user not found' }, status: :not_found
        end
      end

      def remove_members
        group = Group.find(params[:id])
        user = User.find(params[:user_id])
        if group && user
          group.users.delete(user)
          render json: group.users, status: :ok
        else
          render json: { error: 'Group or user not found' }, status: :not_found
        end
      end

      private

      def group_params
        params.require(:group).permit(:name, :description)
      end

      def record_not_found(exception)
        model_name = exception.model.constantize.model_name.human
        render json: { error: "#{model_name} not found" }, status: :not_found
      end
    end
  end
end
