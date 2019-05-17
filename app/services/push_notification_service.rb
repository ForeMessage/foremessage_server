require 'houston'

class PushNotificationService
  def send_message(message_infos, token)
    notification = Houston::Notification.new(device: token)
    notification.alert = message_infos[:message]

    push_setting(notification)

    notification.custom_data = message_infos
    notification.mutable_content = 1

    apn.push(notification)

    notification
  end

  private
  def initialize
    @apn = Houston::Client.production
    @apn.certificate = File.read('/var/www/foremessage_server/shared/cert/foremessage.pem')
  end

  def apn
    @apn
  end

  def push_setting(notification)
    # notification.badge = 1
    notification.sound = 'default'
    # notification.category = 'INVITE_CATEGORY'
    # notification.content_available = true
    # notification.mutable_content = true
    # notification.url_args = %w[boarding A998]
  end
end