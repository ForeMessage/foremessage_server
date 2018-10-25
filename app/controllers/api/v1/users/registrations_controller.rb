class Api::V1::Users::RegistrationsController < ApplicationController

  def sign_up
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.json { render json: { user: @user, message: '유저 생성이 되었습니다.' }, status: :created }
      else
        format.json { render json: @user.errors, status: :bad_request }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:phone_number, :device_id, :name, :birthday)
  end
end