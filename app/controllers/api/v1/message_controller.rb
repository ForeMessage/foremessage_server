class Api::V1::MessageController < ApplicationController
  def send_message
    raise Exceptions::ParameterMissingError.new(:message) unless params[:message].present?
    raise Exceptions::ParameterMissingError.new(:sender) unless params[:sender].present?
    raise Exceptions::ParameterMissingError.new(:receiver) unless params[:receiver].present?

    receiver_array = params[:receiver]

    success_send = []

    receivers = User.where(phone_number: receiver_array)

    receivers.each do |receiver|
      message_info = {
          sender: params[:sender],
          receiver: receiver.phone_number,
          message: params[:message],
          time: Time.now
      }

      message_info.merge!({ send_at: params[:send_at] }) if params[:send_at].present?

      begin
        PushNotificationService.new.send_message(message_info, receiver.token.device_token)
        success_send << receiver.phone_number
      rescue => e
        puts "FAIL SEND MESSAGE => #{e.message}"
      end
    end

    success_response(message: 'SUCCESS SEND MESSAGE', extra_parameters: { success_send: success_send, fail_send: receiver_array - success_send })
  end
end
