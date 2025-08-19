Rails.application.routes.draw do
  get "pages/home"
  devise_for :users

  root "pages#home"

  resources :players do
    get "league_filter", on: :member
    resources :player_auths, only: [ :create, :destroy ]
  end
  resources :teams
  resources :matches do
    get "filter", on: :collection
  end

  resources :leagues do
    resources :league_auths, only: [ :create, :destroy ]
    get :auths_user_section, to: "league_auths#user_section"
    resources :memberships, only: [ :create, :destroy ]
    get :memberships_player_section, to: "memberships#player_section"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
