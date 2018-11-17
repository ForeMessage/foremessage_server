class Api::V1::UsersController < ApplicationController
  skip_before_action :check_access_token, only: [:verify_number, :check_user, :sign_in, :check_in, :sign_up, :refresh_access_token]
  before_action :load_secret_service, only: [:sign_up, :sign_in, :check_in, :refresh_access_token]

  # 번호 인증
  def verify_number
    begin
      authenticate = PhoneAuthenticationService.new

      certification_number = authenticate.send_message(params[:phone_number])
    rescue => e
      render json: { error: e }, status: :bad_request and return
    end

    render json: { certification_number: certification_number, message: 'SUCCESS' }, status: :ok
  end

  # 유저 확인
  def check_user
    phone_number = params[:phone_number]
    device_id = params[:device_id]

    exist_user = false

    user_find_by_phone_number = User.find_by(phone_number: phone_number)

    if user_find_by_phone_number.present?
      user_find_by_phone_number.device_id == device_id ? exist_user = true : update_phone_number(user_find_by_phone_number)
    end

    render json: { exist_user: exist_user }, status: :ok
  end

  def check_in
    user = User.find_by(phone_number: params[:phone_number])

    update_token(user, params[:device_token])

    render json: { access_token: @auth_secret.create_token(user, 'access_token'), refresh_token: user.token.refresh_token }, status: :ok
  end

  def sign_in
    user = User.find_by(phone_number: params[:phone_number])

    begin
      if @auth_secret.valid_refresh_token?(user, params[:refresh_token])
        refresh_token = @auth_secret.create_token(user, 'refresh_token')
        user.token.update_attributes(refresh_token: refresh_token)
      end
      access_token = @auth_secret.create_token(user, 'access_token')

      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok
    rescue => e
      render json: { error: e }, status: :forbidden
    end
  end

  def refresh_access_token
    user = User.find_by(phone_number: params[:phone_number])

    begin
      access_token = @auth_secret.create_token(user, 'access_token') if @auth_secret.valid_refresh_token?(user, params[:refresh_token])

      render json: { access_token: access_token }, status: :ok
    rescue => e
      render json: { error: e }, status: :forbidden
    end
  end

  def sign_up
    begin
      user = User.create(user_params)

      update_token(user, params[:device_token])

      render json: { access_token: @auth_secret.create_token(user, 'access_token'), refresh_token: user.token.refresh_token }, status: :created
    rescue => e
      render json: { error: e }, status: :bad_request
    end
  end

  private
  def user_params
    params.permit(:phone_number, :device_id, :name, :birthday)
  end

  def update_token(user, device_token)
    user.token.update_tokens(device_token)
  end

  def update_phone_number(user)
    after_phone_number = 'deleted_' + user.phone_number
    user.update_attributes(phone_number: after_phone_number)
  end

  def load_secret_service
    @auth_secret = AuthSecretService.new
  end
end