class Api::V1::UsersController < ApplicationController
  skip_before_action :check_access_token, only: [:verify_number, :check_user, :sign_in, :check_in, :sign_up]
  before_action :load_secret_service, only: [:sign_up, :sign_in, :check_in]

  # 번호 인증
  def verify_number
    raise Exceptions::ParameterMissingError.new(:phone_number) unless params[:phone_number].present?

    begin
      authenticate = PhoneAuthenticationService.new

      certification_number = authenticate.send_message(params[:phone_number])
    rescue => e
      error_response(status: :bad_request, message: e.message) and return
    end

    success_response(extra_parameters: { certification_number: certification_number })
  end

  # 유저 확인
  def check_user
    raise Exceptions::ParameterMissingError.new(:phone_number) unless params[:phone_number].present?
    raise Exceptions::ParameterMissingError.new(:device_id) unless params[:device_id].present?

    exist_user = false

    user_find_by_phone_number = User.find_by(phone_number: params[:phone_number])

    if user_find_by_phone_number.present?
      user_find_by_phone_number.device_id == params[:device_id] ? exist_user = true : update_phone_number(user_find_by_phone_number)
    end

    success_response(extra_parameters: { exist_user: exist_user })
  end

  def check_in
    raise Exceptions::ParameterMissingError.new(:phone_number) unless params[:phone_number].present?
    raise Exceptions::ParameterMissingError.new(:device_token) unless params[:device_token].present?

    user = User.find_by(phone_number: params[:phone_number])

    update_token(user, params[:device_token])

    success_response(extra_parameters: { access_token: @auth_secret.create_token(user), refresh_token: user.token.refresh_token })
  end

  def sign_in
    raise Exceptions::ParameterMissingError.new(:phone_number) unless params[:phone_number].present?
    raise Exceptions::ParameterMissingError.new(:refresh_token) unless params[:refresh_token].present?

    user = User.find_by(phone_number: params[:phone_number])

    begin
      access_token = @auth_secret.check_refresh_token(user, params[:refresh_token])

      success_response(extra_parameters: { access_token: access_token, refresh_token: params[:refresh_token] })
    rescue => e
      error_response(status: :forbidden, message: e.message) and return
    end
  end

  def sign_up
    raise Exceptions::ParameterMissingError.new(:device_token) unless params[:device_token].present?

    begin
      user = User.create(user_params)

      update_token(user, params[:device_token])

      success_response(extra_parameters: { access_token: @auth_secret.create_token(user), refresh_token: user.token.refresh_token }, status: :created)
    rescue => e
      error_response(status: :bad_request, message: e.message) and return
    end
  end

  private
  def user_params
    params.permit(:phone_number, :device_id, :name, :birthday)
  end

  def update_token(user, device_token)
    begin
      user.token.update_tokens(device_token)
    rescue => e
      error_response(status: :bad_request, message: e.message) and return
    end
  end

  def update_phone_number(user)
    after_phone_number = 'deleted_' + user.phone_number
    user.update_attributes(phone_number: after_phone_number)
  end

  def load_secret_service
    @auth_secret = AuthSecretService.new
  end
end