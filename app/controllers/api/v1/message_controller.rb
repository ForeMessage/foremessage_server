class Api::V1::MessageController < ApplicationController
  def send_message
    raise Exceptions::ParameterMissingError.new(:message) unless params[:message].present?
    raise Exceptions::ParameterMissingError.new(:sender) unless params[:sender].present?
    raise Exceptions::ParameterMissingError.new(:receiver) unless params[:receiver].present?

    message_info = {
        sender: params[:sender],
        receiver: params[:receiver],
        message: params[:message],
        time: Time.now
    }

    begin
      PushNotificationService.new.send_message(message_info)
    rescue => e
      error_response(status: :bad_request, message: e.message) and return
    end

    success_response(message: 'SUCCESS SEND MESSAGE')
  end
end
