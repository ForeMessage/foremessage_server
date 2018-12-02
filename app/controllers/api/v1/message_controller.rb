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

        begin
          temp_image = StringIO.new(Base64.decode64(params[:image].tr(' ', '+')))
          temp_image.class.class_eval { attr_accessor :original_filename, :content_type }
          temp_image.original_filename = SecureRandom.hex + '.png'
          temp_image.content_type = 'image/png'

          temp_file = file.binmode
          temp_file = file.write temp_image.read

          image = MiniMagick::Image.open(temp_file.path)
        rescue => e
          logger.debug "class: #{temp_file.class}, methods: #{temp_file.methods}"
          error_response(message: 'FAIL', extra_parameters: { class: temp_image.class, methods: temp_image.methods }) and return
        end

        message_info.merge!({ image: image })
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

    receiver = User.where(phone_number: receiver_array).first

    image = MiniMagick::Image.open(params[:image].path)
    image.draw 'image Over 0,0 0,0 "foremessage_logo.png"'

    message_info = {
        sender: params[:sender],
        receiver: receiver.phone_number,
        message: image,
        time: Time.now
    }

    PushNotificationService.new.send_message(message_info, receiver.token.device_token)

    success_response(message: 'SUCCESS SEND SECRET MESSAGE', extra_parameters: { image: image })
  end
end
