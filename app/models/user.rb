class User < ApplicationRecord
  #TODO 백업 파일 아이디 기능 때 추가
  # has_secure_password
  after_create :create_token
  # before_destroy :all_delete_friendships_of_user

  has_one :token, class_name: :UserToken, dependent: :delete
  # has_and_belongs_to_many :friendships,
  #                         class_name: "User",
  #                         join_table:  :friendships,
  #                         foreign_key: :user_id,
  #                         association_foreign_key: :friend_id,
  #                         dependent: :delete_all

  #TODO 삭제
  # scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  # scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }

  def create_payload_hash(token)
    expired_at = token == 'refresh_token' ? Time.now + 6.months : Time.now + 3.hours

    {
        iss: 'foremessage',
        # 'https://api.foremessage.com/': true,
        exp: expired_at,
        iat: Time.now.to_i,
        user_id: self.id,
        user_phone_number: self.phone_number
    }
  end

  private
  def create_token
    self.build_token.save
  end

  # def all_delete_friendships_of_user
  #   Friendship.where(friend_id: self).delete_all
  #   self.friendships.delete_all
  # end
end
