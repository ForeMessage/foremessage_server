class Api::V1::FriendsController < ApplicationController

  def load_birthday
    raise Exceptions::ParameterMissingError.new(:contacts) unless params[:contacts].present?

    contacts = params[:contacts]

    find_user_from_contact = User.where(phone_number: contacts).where("DATE_FORMAT(birthday, '%m%d') = #{Time.now.strftime('%m%d')}")

    if find_user_from_contact.present?
      success_response(extra_parameters: { birthday_friends: find_user_from_contact.select(:id, :phone_number, :name, :birthday) })
    else
      success_response(message: '생일인 친구가 없습니다.')
    end
  end
end