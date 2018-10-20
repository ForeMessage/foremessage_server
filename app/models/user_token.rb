class UserToken < ApplicationRecord
  belongs_to :user

  def refresh_token(device_token)
    # Access Token
    access_token = create_new_access_token

    # Update
    self.update_attributes(access_token: access_token, device_token: device_token)
  end

  private
  def create_new_access_token
    auth_secret = AuthSecretService.new

    payload = self.user.create_payload_hash

    auth_secret.encode(payload)
  end
end
