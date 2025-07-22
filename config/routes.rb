Rails.application.routes.draw do
  devise_for :users

  root "leagues#index"

  resources :players
  resources :teams
  resources :matches do
    get "filter", on: :collection
  end
  resources :leagues

  get "up" => "rails/health#show", as: :rails_health_check
end
