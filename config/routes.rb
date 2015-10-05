Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }, :skip => [:registrations, :sessions]
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/code-review-offers/:id', to: 'code_reviews#show', as: 'code_review_offer'
  get '/code-reviews/:id', to: 'code_reviews#show', as: 'code_review'
  get '/profile', to: 'users#profile', as: 'profile'

  namespace :api do
    get 'topics', to: 'topics#index'
    get 'reviews', to: 'reviews#index'
    get 'review', to: 'reviews#show'
    get 'offers', to: 'offers#index'
    get 'has_offered', to: 'offers#has_offered'
    get 'owned_by', to: 'reviews#owned_by'
    get 'decision_registered', to: 'offers#decision_registered'
    get 'tokens', to: 'tokens#show'
    get 'community_members', to: 'users#index'
    get 'subscriptions', to: 'users#subscriptions'
    post 'update_profile', to: 'users#update'
    post 'offers/deliver', to: 'offers#deliver'
    post 'reviews', to: 'reviews#create'
    post 'tokens', to: 'tokens#create'
    post 'offers/payments', to: 'offers#payments'
    post 'offers', to: 'offers#create'
    post 'comments', to: 'comments#create'
    put 'offers', to: 'offers#update'
    put 'reviews', to: 'reviews#update'
    delete 'reviews/:id', to: 'reviews#destroy'
  end

  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
    get '/api/authorized_user' => 'users/sessions#authorized_user'
    get '/code-reviews', to: 'home#index'

    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'home#splash', as: :unauthenticated_root
    end
  end
end
