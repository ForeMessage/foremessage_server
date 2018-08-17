Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :users do
        collection do
          post 'check_nickname' => :check_nickname
          post 'verify_number' => :verify_phone_number
          post 'sign_in' => :sign_in
          post 'sign_up' => :sign_up
          post 'find_nickname' => :find_nickname
          post 'find_password' => :find_password
        end
      end
    end
  end
end
