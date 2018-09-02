class Api::V1::Users::RecoveriesController < ApplicationController

  def recovery_nickname
    name = params[:name]
    phone_number = params[:phone_number]

    user = User.find_nickname(name, phone_number)

    if user.present?
      render json: { nickname: user.first.nickname }, status: :ok
    else
      render json: { message: '유저를 찾을 수 없습니다.' }, status: :bad_request
    end
  end

  def recovery_password
    nickname = params[:nickname]
    phone_number = params[:phone_number]

    user = User.find_password(nickname, phone_number)

    if user.present?
      render json: { message: 'OK' }, status: :ok
    else
      render json: { message: '유저를 찾을 수 없습니다.' }, status: :bad_request
    end
  end

  def reset_password
    nickname = params[:nickname]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    user = User.find_by_nickname(nickname)
    user.password = password
    user.password_confirmation = password_confirmation
    user.save

    render json: { message: 'OK' }, status: :ok
  end
end