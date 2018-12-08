Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api do
    namespace :v1, :defaults => {:format => :json} do
      scope :users do
        controller :users do
          post 'verify_number' => :verify_number
          post 'check_in' => :check_in
          post 'sign_in' => :sign_in
          post 'sign_up' => :sign_up
          post 'refresh_access_token' => :refresh_access_token

          get 'check_user' => :check_user
        end
      end

      scope :message do
        controller :message do
          post 'send' => :send_message
          post 'send_secret' => :send_secret
        end
      end

      scope :friends do
        controller :friends do
          post 'load_birthday' => :load_birthday
        end
      end
    end
  end
end
