# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET /show' do
    let(:user) { create(:user) }

    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:user) }

      it 'should accept the params with json format' do
        post :create, params: { user: valid_params }
        expect(response.media_type).to eq('application/json')
      end

      it 'creates new user' do
        expect do
          post :create, params: { user: valid_params }
        end.to change(User, :count).by(1)
      end

      it 'returns success status' do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          first_name: 'John',
          last_name: 'Doe',
          email: 'johndoe.gmail.com',
          phone_number: '9999999991',
          password: 'pass123'
        }
      end

      it 'returns error messages in JSON format' do
        post :create, params: { user: invalid_params }, format: :json
        expect(response.media_type).to eq('application/json')
        expect(JSON.parse(response.body)['email']).to include('Is invalid')
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_params }
        end.not_to change(User, :count)
      end

      it 'returns and unprocessable entity response' do
        post :create, params: { user: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let(:valid_params) { { id: user.id, user: { first_name: 'NewName' } } }

      it 'should accept the params with json format' do
        patch :update, params: valid_params
        expect(response.media_type).to eq('application/json')
      end

      it 'updates the user' do
        patch :update, params: valid_params
        user.reload
        expect(user.first_name).to eq('NewName')
      end

      it 'returns a success response' do
        patch :update, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { id: user.id, user: { email: '' } } }

      it 'does not update the user' do
        expect do
          patch :update, params: invalid_params
        end.not_to change{ user.reload.attributes }
      end

      it 'returns an unprocessable entity response' do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE /destroy' do
      let!(:user) { create(:user) }

      it 'destroys the user' do
        expect do
          delete :destroy, params: { id: user.id }
        end.to change(User, :count).by(-1)
      end

      it 'returns a success response' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
