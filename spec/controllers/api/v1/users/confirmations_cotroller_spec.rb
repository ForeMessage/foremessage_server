require 'rails_helper'

RSpec.describe Api::V1::Users::ConfirmationsController, type: :controller do

  describe 'GET check_nickname' do
    let(:user) { FactoryBot.create(:user) }

    it 'CASE: 중복 닉네임' do
      get :check_nickname, :params => { :nickname => 'TEST' }, format: :json

      expect(response).to have_http_status :conflict
    end

    it 'CASE: 중복 되지 않은 닉네임' do
      get :check_nickname, :params => { :nickname => 'available_nickname' }, format: :json

      expect(response).to have_http_status :ok
    end
  end
end