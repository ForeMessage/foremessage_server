Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      namespace :users do
        post 'sign_in' => 'sessions#sign_in'
        post 'sign_up' => 'registrations#sign_up'
        post 'check_nickname' => 'confirmations#check_nickname'
        post 'verify_number' => 'confirmations#verify_phone_number'
        post 'recovery_nickname' => 'recoveries#recovery_nickname'
        post 'recovery_password' => 'recoveries#recovery_password'
        post 'reset_password' => 'recoveries#reset_password'
      end
    end
  end
end
