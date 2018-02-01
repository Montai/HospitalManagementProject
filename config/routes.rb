Rails.application.routes.draw do
  devise_for :users,
              controllers: {
                registrations: "registrations",
                sessions: "sessions"
              }


  devise_scope :user do
    authenticated :user do
      root 'appointments#index', as: :authenticated_root
    end
    unauthenticated do
      root 'sessions#new', as: :unauthenticated_root
    end
    match '/logout', :to => 'devise/sessions#destroy', via: :all
  end

  resources :appointments do
    get :available_slots, on: :collection
    resources :notes, :images
  end

  #patch 'appointments/:id' => "appointments#update_status", as: :update_status
  match 'appointments/:id/update_status' => "appointments#update_status", :via => :post
  match 'appointments/:id/set_date' => "appointments#set_date", :via => :post
  get 'archive' => "appointments#archive"



end
