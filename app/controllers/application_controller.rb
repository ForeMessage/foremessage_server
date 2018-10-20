class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  before_action :check_access_token

  def check_access_token
    auth_secret_service = AuthSecretService.new

    access_token = params[:access_token]
    begin
      body = auth_secret_service.decode(access_token)
    rescue AuthSecretService::TokenExpiredError => e
      render :json => { result: e }, status: :unauthorized
    rescue AuthSecretService::TokenInvalidError => e
      render :json => { result: e }, status: :unauthorized
    end
  end
end
