Rails.application.routes.draw do
  devise_for :users , controllers: {
    registrations: "registrations"
  }

  resources :users

  resources :appointments do
    resources :notes
  end

  #patch 'appointments/:id' => "appointments#update_status", as: :update_status
  match 'appointments/:id/update_status' => "appointments#update_status", :via => :post
  get 'archive' => "appointments#archive"

  root 'appointments#index'

end
