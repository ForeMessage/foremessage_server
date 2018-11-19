class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandling
  skip_before_action :verify_authenticity_token

  before_action :check_access_token

  def check_access_token
    raise Exceptions::RequestHeaderMissingError.new(:Authorization) unless request.headers[:Authorization].present?

    auth_secret_service = AuthSecretService.new

    access_token = request.headers[:Authorization].gsub(/^Bearer /, '')
    begin
      body = auth_secret_service.decode(access_token)
      session[:user_number] = body['user_phone_number']
    rescue AuthSecretService::TokenExpiredError => e
      render :json => { result: e }, status: :unauthorized
      error_response(status: :unauthorized, message: e.message) and return
    rescue AuthSecretService::TokenInvalidError => e
      error_response(status: :unauthorized, message: e.message) and return
    end
  end
end
