Rails.application.routes.draw do
  # User management
  get '/user', to: 'authentication#show_user'
  post '/user/create', to: 'authentication#new_user'

  # Session management
  post '/user/authenticate', to: 'authentication#new_session'

  # Cattle management
  get    'cattle',        to: 'cattle#index'
  get    'cattle/:id',    to: 'cattle#show'
  get    'cattle/search', to: 'cattle#search'
  post   'cattle/new',    to: 'cattle#new'
  put    'cattle/:id',    to: 'cattle#update'
  delete 'cattle/:id',    to: 'cattle#destroy'

  # Health check
  get '/health', to: 'health#index'
  get '/health/login', to: 'health#login_placeholder'

  root to: redirect('//cloud-vm-46-70.doc.ic.ac.uk:80')

end
