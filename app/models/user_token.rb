class UserToken < ApplicationRecord
  belongs_to :user

  def update_tokens(device_token)
    # Access Token
    refresh_token = self.refresh_token.present? ? self.refresh_token : create_new_refresh_token

    # Update
    self.update_attributes(refresh_token: refresh_token, device_token: device_token)
  end

  private
  def create_new_refresh_token
    auth_secret = AuthSecretService.new

    payload = self.user.create_payload_hash

    auth_secret.encode(payload)
  end
end
