class Api::V1::MessageController < ApplicationController
  before_action :notification, only: :send_message


  def send_message
    title = params[:title]
    message = params[:message]

    user = User.find_by(nickname: params[:nickname])

    res = @notification.send_message(user.token.device_token, title, message)

    render json: { res: res.as_json }
  end

  private
  def notification
    @notification = PushNotificationService.new
  end
end
