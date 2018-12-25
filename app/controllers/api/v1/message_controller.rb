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

  def send_reservation
    raise Exceptions::ParameterMissingError.new(:message) unless params[:message].present?
    raise Exceptions::ParameterMissingError.new(:sender) unless params[:sender].present?
    raise Exceptions::ParameterMissingError.new(:receiver) unless params[:receiver].present?

    receiver_array = params[:receiver]

    receivers = User.where(phone_number: receiver_array)

    receivers.each do |receiver|
      link = if params[:image].present?
               temp_image = StringIO.new(Base64.decode64(params[:image].tr(' ', '+')))
               image = MiniMagick::Image.read(temp_image)

               file_name = "#{Base64.encode64(receiver.id.to_s)}_#{Time.now.to_i}.png"

               S3Service.new.upload_image(image, file_name)
             end

      ReservationMessage.create(
          sender: params[:sender],
          receiver: receiver.phone_number,
          receiver_token: receiver.token.device_token,
          message: params[:message],
          image: link,
          send_at: params[:send_at]
      )
    end

    success_response(message: 'SUCCESS SEND MESSAGE TO UNKNOWN')
  end
end
