class User < ApplicationRecord
  has_secure_password
  #before_save :encrypted_password

  CRYPT_KEY = Rails.application.credentials.CRYPT_KEY
  def encrypted_password
    crypt = ActiveSupport::MessageEncryptor.new(CRYPT_KEY)

    password = self.password
    encrypted_data = crypt.encrypt_and_sign(password)
    self.password = encrypted_data
    # crypt.decrypt_and_verify : use decrypt
  end
end
