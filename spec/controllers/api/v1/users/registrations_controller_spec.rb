require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do

  describe 'POST sign_up' do
    it 'CASE: 회원 가입 완료' do
      post :sign_up, :params => { :nickname => 'TEST', :password => 'TEST', :password_confirmation => 'TEST', :phone_number => '010-1111-1111', :name => '테스트', :birth_day => Time.now }, format: :json

      expect(response).to have_http_status :created
    end

    it 'CASE: 회원 가입 실패' do
      post :sign_up, :params => { :nickname => 'TEST', :password => 'TEST', :password_confirmation => '', :phone_number => '010-1111-1111', :name => '테스트', :birth_day => Time.now }, format: :json

      expect(response).to have_http_status :bad_request
    end
  end
end