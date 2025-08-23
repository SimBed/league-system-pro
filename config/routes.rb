Rails.application.routes.draw do
  get "pages/home"
  devise_for :users

  root "pages#home"

  resources :players do
    get "league_filter", on: :member
    resources :player_auths, only: [ :create, :destroy ]
  end
  resources :teams
  resources :matches, except: [ :index ]
  # get "filter", on: :collection

  resources :leagues do
    resources :league_auths, only: [ :create, :destroy ]
    get :auths_user_section, to: "league_auths#user_section"
    resources :memberships, only: [ :create, :destroy ]
    get :memberships_player_section, to: "memberships#player_section"
  end

  scope module: :admin do
    resources :users, only: [ :index, :destroy ] do
      post :impersonate, on: :member, to: "impersonations#create"
    end
    delete "/impersonations/stop", to: "impersonations#destroy", as: :stop_impersonating
  end

  if Rails.env.development?
    get "/debug_session", to: "leagues#show_session"
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
