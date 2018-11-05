class User < ApplicationRecord
  #TODO 백업 파일 아이디 기능 때 추가
  # has_secure_password
  after_create :create_token

  has_one :token, class_name: :UserToken

  #TODO 삭제
  # scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  # scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }

  def create_payload_hash
    {
        iss: 'foremessage',
        # 'https://api.foremessage.com/': true,
        exp: Time.now.tomorrow.to_i,
        iat: Time.now.to_i,
        user_id: self.id,
        user_phone_number: self.phone_number
    }
  end

  private
  def create_token
    self.build_token.save
  end
end
