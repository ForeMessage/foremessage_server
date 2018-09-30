require 'rails_helper'

RSpec.describe Api::V1::Users::RecoveriesController do

  describe 'GET recovery_nickname' do
    let(:user) { FactoryBot.create(:user) }
    params_name = 'test'
    params_phone_number = '010-1111-1111'

    it 'CASE: 닉네임 찾기 성공' do
      get :recovery_nickname, :params => { :name => params_name, :phone_number => params_phone_number }

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET recovery_password' do
    let(:user) { FactoryBot.create(:user) }
    params_nickname = 'TEST'
    params_phone_number = '010-1111-1111'

    it 'CASE: 비밀번호 찾기 성공' do
      get :recovery_password, :params => { :nickname => params_nickname, :phone_number => params_phone_number }, format: :json

      expect(response).to have_http_status :ok
    end
  end

  describe 'PUT reset_password' do
    let(:user) { FactoryBot.create(:user) }

    it 'CASE: 비밀번호 변경' do
      expect(user.authenticate('TEST1').present?).to be true
      put :reset_password, :params => { :nickname => 'TEST', :password => 'password', :password_confirmation => 'password' }

      expect(response).to have_http_status :ok
      expect(user.authenticate('password').present?).to be true
    end
  end
end