Rails.application.routes.draw do
  #
  # Background job monitoring
  #
  mount Sidekiq::Web, at: '/godpanel/jobs'

  #
  # Admin area
  #
  scope '/godpanel' do
    get '/dashboard', to: 'admin#dashboard', as: :admin_dashboard
    get '/users', to: 'admin#users', as: :admin_users

    patch '/connect_as(/:id)', to: 'admin#connect_as', as: :admin_connect_as
    patch '/crawl(/:id)', to: 'admin#crawl', as: :admin_crawl
  end

  #
  # Omniauth
  #
  get '/users/auth/:provider/callback', to: 'omniauth_callbacks#callback'
  get '/auth/failure', to: 'omniauth_callbacks#failure'

  #
  # Signup from website
  #
  post '/create-account', to: 'api/v1/registrations#create_account'

  #
  # API
  #
  namespace 'api', module: 'api' do
    namespace 'v1', module: 'v1' do
      # Webhooks
      post '/webhooks/stripe',   to: 'webhooks#stripe'

      # Registrations
      get '/registrations', to: 'registrations#show'
      post '/registrations', to: 'registrations#create'
      patch '/registrations', to: 'registrations#update'
      patch '/registrations/confirm/:token', to: 'registrations#confirm'

      # Sessions
      get '/sessions', to: 'sessions#show'
      get '/sessions/user', to: 'sessions#user'
      get '/sessions/organization', to: 'sessions#organization'
      post '/sessions', to: 'sessions#create'
      delete '/sessions', to: 'sessions#destroy'

      # Passwords
      post '/passwords', to: 'passwords#create'
      patch '/passwords', to: 'passwords#update'

      # Organizations
      get '/organizations', to: 'organizations#index'
      post '/organizations', to: 'organizations#create'
      get '/organizations/:id', to: 'organizations#show'
      patch '/organizations/:id', to: 'organizations#update'
      delete '/organizations/:id', to: 'organizations#destroy'

      # Identities
      delete '/identities/:id', to: 'identities#destroy'

      # Reports
      get '/reports/revenues', to: 'reports#revenues'
      get '/reports/customers', to: 'reports#customers'
      get '/reports/subscriptions', to: 'reports#subscriptions'

      # Goals
      get '/goals', to: 'goals#index'
      post '/goals', to: 'goals#create'
      post '/goals/batch_upsert', to: 'goals#batch_upsert'
      post '/goals/set_goals', to: 'goals#set_goals'
      get '/goals/:id', to: 'goals#show'
      patch '/goals/:id', to: 'goals#update'
      delete '/goals/:id', to: 'goals#destroy'

      # Customers
      get '/customers', to: 'customers#index'
      get '/customers/:id', to: 'customers#show'

      # Plans
      get '/plans', to: 'plans#index'
    end
  end

  constraints subdomain: 'app' do
    get '/', to: 'pages#app', as: :app
    get '*path' => 'pages#app'
  end

  constraints subdomain: '' do
    get '/', to: 'pages#index', as: :website
  end

  constraints subdomain: 'www' do
    get '/', to: redirect('/', subdomain: '')
  end
end
