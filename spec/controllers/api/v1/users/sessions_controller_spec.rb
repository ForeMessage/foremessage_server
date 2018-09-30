require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :controller do

  describe 'POST sign_in' do
    user =  FactoryBot.create(:user)

    it 'CASE: 로그인 완료' do
      post :sign_in, :params => { :nickname => user.nickname, :password => 'TEST1' }

      expect(response).to have_http_status :success
    end

    it 'CASE: 알 수 없는 유저 닉네임' do
      post :sign_in, :params => { :nickname => 'invalid_user', :password => 'TEST1' }

      expect(response).to have_http_status :bad_request
    end

    it 'CASE: 비밀번호가 틀림' do
      post :sign_in, :params => { :nickname => user.nickname, :password => 'TEST' }

      expect(response).to have_http_status :unauthorized
    end
  end
end