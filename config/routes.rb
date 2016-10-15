Rails.application.routes.draw do
  get 'health', to: 'health#index'

  # root 'WelcomeController#index'
end
