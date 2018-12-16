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

      if params[:image].present?
        temp_image = StringIO.new(Base64.decode64(params[:image].tr(' ', '+')))
        image = MiniMagick::Image.read(temp_image)

        file_name = "#{Base64.encode64(receiver.id.to_s)}_#{Time.now.to_i}.png"

        link = S3Service.new.upload_image(image, file_name)

        message_info.merge!({ image: link })
      end

      begin
        PushNotificationService.new.send_message(message_info, receiver.token.device_token)
        success_send << receiver.phone_number
      rescue => e
        puts "FAIL SEND MESSAGE => #{e.message}"
      end
    end

    success_response(message: 'SUCCESS SEND MESSAGE', extra_parameters: { success_send: success_send, fail_send: receiver_array - success_send })
  end

  def send_secret
    receiver_array = params[:receiver]

    receivers = User.where(phone_number: receiver_array)
    non_users = receiver_array - receivers.pluck(:phone_number)
    PhoneAuthenticationService.new.send_message_to_unknown(non_users, params[:sender])

    temp_image = StringIO.new(Base64.decode64(params[:image].tr(' ', '+')))
    image = MiniMagick::Image.read(temp_image)
    image.draw "image Over 85,220 0,0 'message_logo.png'"

    link = S3Service.new.upload_image(image, 'test.png')

    receivers.each do |receiver|
      message_info = {
          sender: params[:sender],
          receiver: receiver.phone_number,
          message: link,
          time: Time.now
      }

      PushNotificationService.new.send_message(message_info, receiver.token.device_token)
    end

    success_response(message: 'SUCCESS SEND SECRET MESSAGE', extra_parameters: { image: link })
  end

  def send_check_push
    receiver = User.find_by(phone_number: params[:receiver])
    receiver_name = params[:receiver_name]
    sender = params[:sender]
    sender_name = params[:sender_name]

    message_info = {
        sender: sender,
        receiver: receiver.phone_number,
        message: "#{sender_name}님이 보낸 등기 메시지를 #{receiver_name}님이 확인하였습니다."
    }

    PushNotificationService.new.send_message(message_info, receiver.token.device_token)

    success_response(message: 'SUCCESS SEND SECRET MESSAGE')
  end

  def send_confirm_push
    receiver = User.find_by(phone_number: params[:receiver])
    receiver_name = params[:receiver_name]
    sender = params[:sender]
    sender_name = params[:sender_name]

    message_info = {
        sender: sender,
        receiver: receiver.phone_number,
        message: "#{sender_name}님이 등기 메시지를 보냈습니다. 확인해주세요!"
    }

    PushNotificationService.new.send_message(message_info, receiver.token.device_token)

    success_response(message: 'SUCCESS SEND SECRET MESSAGE')
  end
end
