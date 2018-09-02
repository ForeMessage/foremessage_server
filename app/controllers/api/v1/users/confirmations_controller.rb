class Api::V1::Users::ConfirmationsController < ApplicationController

  def check_nickname
    nickname = params[:nickname]

    respond_to do |format|
      if User.find_by_nickname(nickname)
        format.json { render json: { message: '이미 가입되어 있는 닉네임 입니다.'}, status: :conflict }
      else
        format.json { render json: { message: 'SUCCESS' }, status: :ok}
      end
    end
  end

  def verify_phone_number
    phone_number = params[:phone_number]

    sns = Aws::SNS::Client.new(region: 'ap-northeast-1', access_key_id: Rails.application.credentials[:access_key_id], secret_access_key: Rails.application.credentials[:secret_access_key])

    certification_number = rand(1000..9999)

    begin
      sns.publish(phone_number: "+82#{phone_number}", message: "foremessage의 인증 번호는 #{certification_number}입니다.")
      render json: { certification_number: certification_number, message: 'SUCCESS' }, status: :ok
    rescue => e
      render json: { message: e }, status: :bad_request
    end
  end
end