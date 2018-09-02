class User < ApplicationRecord
  has_secure_password

  scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number) }
  scope :find_password, -> (nickname, phone_number) { where(:nickname => nickname, :phone_number => phone_number) }
end
