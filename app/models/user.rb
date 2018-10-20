class User < ApplicationRecord
  has_secure_password
  after_create :create_token

  has_one :token, class_name: :UserToken

  scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }


  def create_payload_hash
    {
        id: self.id,
        nickname: self.nickname,
        expired_at: Time.now.tomorrow,
        created_at: self.created_at
    }
  end
  private
  def create_token
    self.build_token.save
  end
end
