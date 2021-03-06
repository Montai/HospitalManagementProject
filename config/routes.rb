require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'appointments#index' #Root Path
  devise_for :users, controllers: {
                registrations: "registrations",
                omniauth_callbacks: 'users/omniauth_callbacks',
                sessions: "sessions"
  }
  devise_scope :user do
    authenticated :user do
      root 'appointments#index', as: :authenticated_root
    end
    unauthenticated :user do
      root 'sessions#new', as: :unauthenticated_root
    end
    match '/logout', :to => 'devise/sessions#destroy', via: :all
  end
  resources :appointments do
    get :get_slots, on: :collection
    resources :notes, except: [:show]
    resources :images, only: [:show]
  end
  match 'appointments/:id/cancel_appointment' => "appointments#cancel_appointment", :via => :post
  match 'appointments/:id/visited_patient_appointment' => "appointments#visited_patient_appointment", :via => :post
  get 'archive' => "appointments#archive"
end
