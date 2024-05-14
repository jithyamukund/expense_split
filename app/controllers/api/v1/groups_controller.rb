# frozen_string_literal: true

# Controller for managing groups in the API version 1 namespace.
class Api::V1::GroupsController < ApplicationController
  before_action :set_group, only: %i[show update destroy]

  def index
    @groups = Group.all
    render json: @groups
  end

  def show
    render json: @group
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      render json: @group, status: :created
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      render json: @group, status: :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @group.destroy
      render json: @group, status: :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
