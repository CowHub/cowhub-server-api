Rails.application.routes.draw do
  # User management
  get '/user', to: 'authentication#show_user'
  post '/user/create', to: 'authentication#new_user'

  # Session management
  post '/user/validate', to: 'authentication#validate_session'
  post '/user/authenticate', to: 'authentication#new_session'
  delete '/user/unauthenticate', to: 'authentication#end_session'

  # Cattle management
  get    '/cattle',        to: 'cattle#index'
  get    '/cattle/:id',    to: 'cattle#show'
  get    '/cattle/search', to: 'cattle#search'
  post   '/cattle/new',    to: 'cattle#new'
  put    '/cattle/:id',    to: 'cattle#update'
  delete '/cattle/:id',    to: 'cattle#destroy'

  # Image management
  get    '/cattle/:id/images/', to: 'image#index'
  get    '/cattle/image/:id',   to: 'image#show'
  post   '/cattle/:id/images/', to: 'image#upload'

  # Match management
  post   '/cattle/match',                   to: 'match#new'
  get    '/cattle/match/:id',               to: 'match#show'
  post   '/cattle/match/:id/lambda',        to: 'lambda#match_result'
  post   '/cattle/match/:id/lambda/count',  to: 'lambda#match_count'

  # Health check
  get '/health', to: 'health#index'
  get '/health/login', to: 'health#login_placeholder'

  root to: redirect('//cowhub.co.uk:80')
end
