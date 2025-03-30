Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes with versioning
  api_version(module: 'V1', header: { name: 'Accept', value: 'application/vnd.finance_manager+json; version=1' }) do
    # Authentication routes
    post 'auth/register', to: 'auth#register'
    post 'auth/login', to: 'auth#login'
    
    # Bank accounts routes
    resources :bank_accounts do
      # Nested transactions routes
      resources :transactions
    end
  end
end
