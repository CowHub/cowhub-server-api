Rails.application.routes.draw do
  # User management
  get '/user', to: 'authentication#show_user'
  post '/user/create', to: 'authentication#new_user'

  # Session management
  post '/user/authenticate', to: 'authentication#new_session'

  get '/health', to: 'health#index'
  get '/health/login', to: 'health#login_placeholder'

  root to: redirect('https://cowhub.io')
end
