Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api do
    namespace :v1, :defaults => {:format => :json} do
      namespace :users do
        post 'sign_in' => 'sessions#sign_in'
        post 'sign_up' => 'registrations#sign_up'
        post 'verify_number' => 'confirmations#verify_phone_number'
        put 'reset_password' => 'recoveries#reset_password'
        get 'check_nickname' => 'confirmations#check_nickname'
        get 'recovery_nickname' => 'recoveries#recovery_nickname'
        get 'recovery_password' => 'recoveries#recovery_password'
      end

      controller :message do
        post 'send_message' => :send_message
      end
    end
  end
end
