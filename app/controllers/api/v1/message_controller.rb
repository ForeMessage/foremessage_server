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
        logger.debug "FAIL SEND MESSAGE => #{e.message}"
      end
    end

    success_response(message: 'SUCCESS SEND MESSAGE', extra_parameters: { success_send: success_send, fail_send: receiver_array - success_send })
  end

  def send_reservation
    raise Exceptions::ParameterMissingError.new(:message) unless params[:message].present?
    raise Exceptions::ParameterMissingError.new(:sender) unless params[:sender].present?
    raise Exceptions::ParameterMissingError.new(:receiver) unless params[:receiver].present?

    receiver_array = params[:receiver]
    reservation_messages = []

    receivers = User.where(phone_number: receiver_array)

    receivers.each do |receiver|
      link = if params[:image].present?
               temp_image = StringIO.new(Base64.decode64(params[:image].tr(' ', '+')))
               image = MiniMagick::Image.read(temp_image)

               file_name = "#{Base64.encode64(receiver.id.to_s)}_#{Time.now.to_i}.png"

               S3Service.new.upload_image(image, file_name)
             end

      reservation_message = ReservationMessage.create(
          sender: params[:sender],
          receiver: receiver.phone_number,
          receiver_token: receiver.token.device_token,
          message: params[:message],
          image: link,
          send_at: params[:send_at]
      )

      reservation_messages << reservation_message.id
    end

    success_response(message: 'SUCCESS SEND MESSAGE TO UNKNOWN', extra_parameters: { reservation_id: "#{reservation_messages.first}..#{reservation_messages.last}" })
  end

  def delete_reservation
    raise Exceptions::ParameterMissingError.new(:reservation_id) unless params[:reservation_id].present?

    puts params[:reservation_id]
    message_array = params[:reservation_id].split('..')
    range = Range.new(message_array[0], message_array[1])

    delete_size = ReservationMessage.where(id: range.to_a).delete_all

    success_response(message: "SUCCESS DELETE RESERVATION MESSAGE => #{delete_size}")
  end

  def delete_image
    raise Exceptions::ParameterMissingError.new(:link) unless params[:link].present?

    file_name = params[:link].split('/').last
    S3Service.new.delete_image(file_name)

    success_response(message: "SUCCESS DELETE IMAGE => #{file_name}")
  end
end
