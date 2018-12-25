namespace :reservation_message do
  desc "예약메시지 발송"
  task send: :environment do
    target_messages = ReservationMessage.where("MINUTE(send_at) = MINUTE(NOW())")

    puts "예약 메시지 개수: #{target_messages.size}"

    target_messages.each do |message|
      message_info = {
          sender: message.sender,
          receiver: message.receiver,
          message: message.message,
          time: Time.now
      }

      message_info.merge!({ image: message.image }) if message.image.present?

      PushNotificationService.new.send_message(message_info, message.receiver_token)
      puts "SEND SUCCESS #{message.id}"
    end
    target_messages.delete_all
    puts "예약 메시지 삭제"
  end
end
