class User < ApplicationRecord
  has_secure_password
  after_create :create_token

  has_one :token, class_name: :UserToken

  scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }


  def create_payload_hash
    {
        iss: 'foremessage',
        'https://api.foremessage.com/': true,
        exp: Time.now.tomorrow.to_i,
        iat: Time.now.to_i,
        userId: u.id
    }
  end

  private
  def create_token
    self.build_token.save
  end
end
