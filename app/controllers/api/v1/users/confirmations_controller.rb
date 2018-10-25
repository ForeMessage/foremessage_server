class Api::V1::Users::ConfirmationsController < ApplicationController

  #TODO 삭제
  # def check_nickname
  #   nickname = params[:nickname]
  #
  #   respond_to do |format|
  #     if User.find_by_nickname(nickname)
  #       format.json { render json: { message: '이미 가입되어 있는 닉네임 입니다.'}, status: :conflict }
  #     else
  #       format.json { render json: { message: 'SUCCESS' }, status: :ok}
  #     end
  #   end
  # end

  # def verify_phone_number
  #   begin
  #     authenticate = PhoneAuthenticationService.new
  #
  #     certification_number = authenticate.send_message(params[:phone_number])
  #     render json: { certification_number: certification_number, message: 'SUCCESS' }, status: :ok
  #   rescue => e
  #     render json: { message: e }, status: :bad_request
  #   end
  # end
end