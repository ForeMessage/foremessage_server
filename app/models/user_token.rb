class UserToken < ApplicationRecord
  belongs_to :user

  def update_tokens(device_token)
    # Access Token
    refresh_token = self.refresh_token.present? ? self.refresh_token : AuthSecretService.new.create_token(self.user, 'refresh_token')

    # Update
    self.update_attributes(refresh_token: refresh_token, device_token: device_token)
  end
end
