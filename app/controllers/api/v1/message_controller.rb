class Api::V1::MessageController < ApplicationController
  before_action :notification, only: :send_message


  def send_message
    message = params[:message]
    receiver = params[:receiver]
    sender = params[:sender]

    message_info = {
        sender: sender,
        receiver: receiver,
        message: message,
        time: Time.now
    }

    res = @notification.send_message(message_info)

    render json: { res: res.as_json }
  end

  private
  def notification
    @notification = PushNotificationService.new
  end
end
