class Api::V1::Users::SessionsController < ApplicationController

  def sign_in
    nickname = params[:nickname]
    password = params[:password]

    user = User.find_by(nickname: nickname)

    # 유저 닉네임을 못 찾을 때
    render json: { message: 'invalid nickname' }, status: :bad_request and return unless user.present?

    # 비밀번호가 맞지 않을 때
    render json: { message: 'invalid password' }, status: :unauthorized and return unless user.authenticate(password)

    user.refresh_device_token(params[:device_token])

    # SUCCESS LOGIN
    render json: { message: 'success login' }, status: :ok
  end
end