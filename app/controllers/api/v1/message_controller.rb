class Api::V1::MessageController < ApplicationController
  before_action :notification, only: :send_message


  def send_message
    message = params[:message]
    receiver = params[:receiver]

    message_info = {
        sender: session[:user_number],
        receiver: receiver,
        message: message,
        time: Time.now
    }

    begin
      @notification.send_message(message_info)
    rescue => e
      render json: { error: e }, status: :bad_request and return
    end

    render json: { }, status: :ok
  end

  private
  def notification
    @notification = PushNotificationService.new
  end
end
