Rails.application.routes.draw do
  get "pages/home"
  devise_for :users

  root "pages#home"

  resources :players do
    get "league_filter", on: :member
  end
  resources :teams
  resources :matches do
    get "filter", on: :collection
  end

  resources :leagues do
    resources :league_auths, only: [ :create, :destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
