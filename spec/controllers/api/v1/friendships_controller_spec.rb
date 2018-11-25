require 'rails_helper'
require "rack/test"
include Rack::Test::Methods

RSpec.describe Api::V1::FriendshipsController, type: :controller do

  describe 'POST load' do
    let!(:user) { FactoryBot.create :user }
    let!(:friend1) { FactoryBot.create :user, phone_number: '01011111112' }
    let!(:friend2) { FactoryBot.create :user, phone_number: '01011111113' }
    let!(:friend3) { FactoryBot.create :user, phone_number: '01011111114' }

    context '친구목록 불러오기 성공' do
      it do
        token = AuthSecretService.new.create_token(user, 'access_token')
        # user.token.update_attributes(refresh_token: token)
        request.headers['Authorization'] = "Bearer #{token}"
        contacts = '["01011111112", "01011111113", "01011111115", "01011111116"]'
        post :load_friendships, params: { contacts: contacts }

        body = JSON.parse(response.body)

        expect(body['data']['friendships']).to eq user.friendships.pluck(:id, :phone_number, :name, :birthday).as_json
        expect(body['data']['unknowns']).to eq ['01011111115', '01011111116']
      end
    end
  end
end
