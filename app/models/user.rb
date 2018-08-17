class User < ApplicationRecord
  has_secure_password


  scope :find_nickname, -> (name, phone_number) { where(:name => name, :phone_number => phone_number).limit(1) }
end
