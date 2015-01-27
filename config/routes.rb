Rails.application.routes.draw do

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  get '/code-review-offers/:id', to: 'review_requests#show', as: 'code_review_offer'
  get '/code-reviews/:id', to: 'review_requests#show', as: 'code_review'

  namespace :api do
    post 'offers', to: 'offers#create'
    post 'offer_decisions', to: 'offers#update'
    post 'reviews', to: 'reviews#create'
    get 'has_offered', to: 'offers#has_offered'
    get 'owned_by', to: 'reviews#owned_by'

  end

  devise_scope :user do
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
