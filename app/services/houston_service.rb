require 'houston'

class HoustonService
  def send_message(device_token, title, message)
    notification = Houston::Notification.new(device: device_token)
    notification.alert = message

    push_setting(notification)

    notification.custom_data = { title: title, message: message }

    apn.push(notification)

    notification.custom_data
  end

  private
  def initialize
    @apn = Houston::Client.development
    @apn.certificate = File.read('./fome_development_push.pem')
  end

  def apn
    @apn
  end

  def push_setting(notification)
    # notification.badge = 57
    # notification.sound = 'sosumi.aiff'
    # notification.category = 'INVITE_CATEGORY'
    # notification.content_available = true
    # notification.mutable_content = true
    # notification.url_args = %w[boarding A998]
  end
end