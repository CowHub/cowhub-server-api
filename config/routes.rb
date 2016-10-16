Rails.application.routes.draw do
  post 'user/authenticate', to: 'authentication#authenticate_user'

  get 'health', to: 'health#index'
  get 'health/login', to: 'health#login_placeholder'

  # root 'WelcomeController#index'
end
