class User < ApplicationRecord
  has_secure_password
  after_create :create_token

  has_one :token, class_name: :UserToken

  scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }

  def refresh_device_token(device_token)
    user_token = self.token
    user_token.update_attributes(device_token: device_token) unless user_token.device_token == device_token
  end

  private
  def create_token
    self.build_token.save
  end
end
