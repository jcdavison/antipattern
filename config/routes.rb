Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }, :skip => [:registrations, :sessions]
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/code-review-offers/:id', to: 'code_reviews#show', as: 'code_review_offer'
  get '/code-reviews/:id', to: 'code_reviews#show', as: 'code_review'
  get '/settings', to: 'users#settings', as: 'settings'
  patch '/users', to: 'users#update', as: 'users'
  post '/foo', to: 'home#exp'

  namespace :api do
    get 'topics', to: 'topics#index'
    get 'entities', to: 'entities#index'
    get 'repositories', to: 'repositories#index'
    get 'branches', to: 'branches#index'
    get 'commits', to: 'commits#index'
    get 'reviews', to: 'reviews#index'
    get 'review', to: 'reviews#show'
    get 'offers', to: 'offers#index'
    get 'has_offered', to: 'offers#has_offered'
    get 'owned_by', to: 'reviews#owned_by'
    get 'decision_registered', to: 'offers#decision_registered'
    get 'tokens', to: 'tokens#show'
    get 'community_members', to: 'users#index'
    get 'channels', to: 'notifications#index'
    get 'subscriptions', to: 'subscriptions#index'
    get 'comments', to: 'comments#show'
    get 'comments/:id/sentiments', to: 'comments_sentiments#show'
    get 'comments-index', to: 'comments#index'
    post 'update_profile', to: 'users#update'
    post 'offers/deliver', to: 'offers#deliver'
    post 'reviews', to: 'reviews#create'
    post 'tokens', to: 'tokens#create'
    post 'offers/payments', to: 'offers#payments'
    post 'offers', to: 'offers#create'
    post 'votes', to: 'votes#create'
    post 'comments', to: 'comments#create'
    post 'hooks/code_review/:repo_name', to: 'hooks#consume'
    post 'comments/:id/sentiments', to: 'comments_sentiments#create'
    put 'offers', to: 'offers#update'
    put 'reviews', to: 'reviews#update'
    patch 'subscriptions', to: 'subscriptions#update'
    delete 'reviews/:id', to: 'reviews#destroy'
  end

  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
    get '/api/authorized_user' => 'users/sessions#authorized_user'
  end

  get '/comment-feedback', to: 'comments#index'
  get '/comment-show', to: 'comments#show'
  get '/code-reviews', to: 'code_reviews#index'
  root 'home#splash'
end
