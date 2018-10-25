class Api::V1::Users::SessionsController < ApplicationController

  #TODO 핸드폰 인증으로 변경
  # def sign_in
  #   nickname = params[:nickname]
  #   password = params[:password]
  #
  #   user = User.find_by(nickname: nickname)
  #
  #   # 유저 닉네임을 못 찾을 때
  #   render json: { message: 'invalid nickname' }, status: :bad_request and return unless user.present?
  #
  #   # 비밀번호가 맞지 않을 때
  #   render json: { message: 'invalid password' }, status: :unauthorized and return unless user.authenticate(password)
  #
  #   user.token.refresh_token(params[:device_token])
  #
  #   # SUCCESS LOGIN
  #   render json: { message: 'success login' }, status: :ok
  # end

  def verify_number
    # 이미 등록된 디바이스 아이디 체크
    # existing_user = User.find_by_device_id(params[:device_id]).present? ? true : false

    # 번호 인증
    begin
      authenticate = PhoneAuthenticationService.new

      certification_number = authenticate.send_message(params[:phone_number])
    rescue => e
      render json: { message: e }, status: :bad_request
    end

    render json: { certification_number: certification_number, message: 'SUCCESS' }, status: :ok
  end


end