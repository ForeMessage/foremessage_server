class Api::V1::FriendshipsController < ApplicationController

  def load_friendships
    raise Exceptions::ParameterMissingError.new(:contacts) unless params[:contacts].present?

    contact = params[:contacts]

    find_user_from_contact = User.where(phone_number: contact)

    if find_user_from_contact.present?
      session[:user].friendships << find_user_from_contact

      success_response(extra_parameters: { friendships: session[:user].friendships.select(:id, :phone_number, :name, :birthday), unknowns: contact - find_user_from_contact.pluck(:phone_number) })
    else
      error_response(message: 'DO NOT LOAD FRIEND LIST')
    end
  end
end