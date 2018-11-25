class Api::V1::FriendshipsController < ApplicationController

  def load_friendships
    raise Exceptions::ParameterMissingError.new(:contacts) unless params[:contacts].present?

    contact = JSON.parse(params[:contacts])

    find_user_from_contact = User.where(phone_number: contact)

    session[:user].friendships << find_user_from_contact

    success_response(extra_parameters: { friendships: session[:user].friendships.pluck(:id, :phone_number, :name, :birthday), unknowns: contact - find_user_from_contact.pluck(:phone_number) })
  end
end