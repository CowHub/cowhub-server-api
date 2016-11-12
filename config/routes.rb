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
  post   '/cattle/:id/images/', to: 'image#upload'
  post   '/image/verify', to: 'image#request_verification'
  get    '/image/verify', to: 'image#check_verification'

  # Health check
  get '/health', to: 'health#index'
  get '/health/login', to: 'health#login_placeholder'

  root to: redirect('//cloud-vm-46-70.doc.ic.ac.uk:80')
end
