require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET check_user' do
    let!(:user) { FactoryBot.create :user }

    context 'CASE: 정상적으로 회원 가입 가능한 유저' do
      it do
        get :check_user, params: { phone_number: '01012341234', device_id: 'test_device_2' }

        body = JSON.parse(response.body)
        expect(body['exist_user']).to eq false
      end
    end

    context 'CASE: 같은 번호,같은 기기 재 로그인' do
      it do
        get :check_user, params: { phone_number: '01011111111', device_id: 'test_device_1' }

        body = JSON.parse(response.body)
        expect(body['exist_user']).to eq true
      end
    end

    context 'CASE: 다른 기기로 재 로그인' do
      it do
        get :check_user, params: { phone_number: '01011111111', device_id: 'test_device_2' }
        user.reload

        body = JSON.parse(response.body)
        expect(body['exist_user']).to eq false
        expect(user.phone_number).to eq 'deleted_01011111111'
      end
    end
  end

  describe 'POST check_in' do
    let!(:user) { FactoryBot.create :user }

    context 'CASE: 로그인 성공' do
      it do
        post :check_in, params: { phone_number: '01011111111', device_token: 'test_device_token' }
        user.reload

        body = JSON.parse(response.body)
        expect(user.token.device_token).to eq 'test_device_token'

        access_token_body = AuthSecretService.new.decode body['access_token']
        refresh_token_body = AuthSecretService.new.decode body['refresh_token']

        expect(access_token_body['user_id']).to eq user.id
        expect(refresh_token_body['user_id']).to eq user.id
      end
    end
  end

  describe 'POST sign_in' do
    let!(:user) { FactoryBot.create :user }

    context 'CASE: 자동 로그인 성공' do
      it do
        token = AuthSecretService.new.create_token(user, 'refresh_token')
        user.token.update_attributes(refresh_token: token)
        post :sign_in, params: { phone_number: '01011111111', refresh_token: token }

        body = JSON.parse(response.body)

        access_token_body = AuthSecretService.new.decode body['access_token']
        refresh_token_body = AuthSecretService.new.decode body['refresh_token']

        expect(access_token_body['user_id']).to eq user.id
        expect(refresh_token_body['user_id']).to eq user.id
      end
    end

    context 'CASE: Invalid Refresh Token' do
      it do
        token = AuthSecretService.new.create_token(user, 'refresh_token')
        user.token.update_attributes(refresh_token: token)
        post :sign_in, params: { phone_number: '01011111111', refresh_token: 'invalid_token' }

        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'POST refresh_access_token' do
    let!(:user) { FactoryBot.create :user }

    context 'CASE: 엑세스 토큰 갱신 성공' do
      it do
        token = AuthSecretService.new.create_token(user, 'refresh_token')
        user.token.update_attributes(refresh_token: token)
        post :refresh_access_token, params: { phone_number: '01011111111', refresh_token: token }

        body = JSON.parse(response.body)

        access_token_body = AuthSecretService.new.decode body['access_token']
        expect(access_token_body['user_id']).to eq user.id
      end
    end
  end
end