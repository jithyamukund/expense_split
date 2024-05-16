require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do

  describe 'GET /show' do
    let(:group) { Group.create(name: "Example Group 1", description: "Sample Description") }

    it 'returns a success response' do
      get :show, params: { id: group.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_params) { { name: 'Example Group 1', description: "Sample Description" } }

      it 'should accept the params with json format' do
        post :create, params: { group: valid_params }
        expect(response.media_type).to eq('application/json')
      end

      it 'creates new group' do
        expect do
          post :create, params: { group: valid_params }
        end.to change(Group, :count).by(1)
      end

      it 'returns success status' do
        post :create, params: { group: valid_params }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { {name: '', description: '' } }

      it 'returns error messages in JSON format' do
        post :create, params: { group: invalid_params }, format: :json
        expect(response.media_type).to eq('application/json')
        expect(JSON.parse(response.body)['name']).to include("can't be blank")
      end

      it 'does not create a new group' do
        expect do
          post :create, params: { group: invalid_params }
        end.not_to change(Group, :count)
      end

      it 'returns and unprocessable entity response' do
        post :create, params: { group: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    let(:group) { Group.create(name: "Example Group 1", description: "Sample Description") }

    context 'with valid params' do
      let(:valid_params) { { id: group.id, group: { name: 'NewName_1' } } }

      it 'should accept the params with json format' do
        patch :update, params: valid_params
        expect(response.media_type).to eq('application/json')
      end

      it 'updates the group' do
        patch :update, params: valid_params
        group.reload
        expect(group.name).to eq('NewName_1')
      end

      it 'returns a success response' do
        patch :update, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { id: group.id, group: { name: '' , description: ''} } }

      it 'does not update the group' do
        expect do
          patch :update, params: invalid_params
        end.not_to change{ group.reload.attributes }
      end

      it 'returns an unprocessable entity response' do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE /destroy' do
      let!(:group) { Group.create(name: "Example Group 1", description: "Sample Description") }

      it 'destroys the group' do
        expect do
          delete :destroy, params: { id: group.id }
        end.to change(Group, :count).by(-1)
      end

      it 'returns a success response' do
        delete :destroy, params: { id: group.id }
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /add_members' do
      let(:group) { Group.create(name: "Example Group 1", description: "Sample Description") }
      let(:user) { create(:user) }

      context 'when group and user exist' do
        before do
          post :add_members, params: { id: group.id, user_id: user.id }
        end

        it 'adds the user to the group' do
          expect(group.users).to include(user)
        end

        it 'returns a successful response with the updated group users' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when Group does not exist' do
        before do
          post :add_members, params: { id: "invalid", user_id: user.id }
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['error']).to eq('Group not found')
        end
      end

      context 'when User does not exist' do
        before do
          post :add_members, params: { id: group.id, user_id: 'invalid' }
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['error']).to eq('User not found')
        end
      end
    end

    describe 'POST /remove_members' do
      let(:group) { Group.create(name: "Example Group 1", description: "Sample Description") }
      let(:user) { create(:user) }

      context 'when group and user exist' do
        before do
          GroupUser.create(user: user, group: group)
          post :remove_members, params: { id: group.id, user_id: user.id }
        end

        it 'removes the user from the group' do
          expect(group.users).not_to include(user)
        end

        it 'returns a successful response with the updated group users' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'When Group does not exist' do
        before do
          post :remove_members, params: { id: 'invalid', user_id: user.id }
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['error']).to eq('Group not found')
        end
      end

      context 'When User does not exist' do
        before do
          post :remove_members, params: { id: group.id, user_id: 'invalid' }
        end

        it 'returns a not found response' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['error']).to eq('User not found')
        end
      end
    end
  end
end
