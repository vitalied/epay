Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Settings.sidekiq_username)) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Settings.sidekiq_password))
  end unless Rails.env.development?
  mount Sidekiq::Web, at: '/sidekiq'

  devise_for :users

  unauthenticated do
    root to: 'dashboard#index'
  end

  authenticated :user do
    root to: 'dashboard#index', as: :merchant_root

    get '/dashboard', to: 'dashboard#index', as: :merchant_dashboard
    resources :transactions, only: :index, as: :merchant_transactions

    namespace :api, defaults: { format: 'json' } do
      resources :transactions, only: :create
    end
  end

  # this needs to go last!
  match '/:anything', to: 'application_public#routing_error', constraints: { anything: /.*/ }, via: :all
end
