Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "decks", to: "decks#index"
    get "decks/:id", to: "decks#show"
    post "decks", to: "decks#create"
    patch "decks/:id", to: "decks#update"
    delete "decks/:id", to: "decks#destroy"

    get "decks/:deck_id/cards", to: "cards#index"
    post "decks/:deck_id/cards", to: "cards#create"
    delete "cards/:id", to: "cards#destroy"
    patch "cards/:id", to: "cards#update"
    post "cards/:id/done", to: "cards#done"

    post "auth/google_oauth2/callback", to: "authentications#google_oauth2"

    resources :users, only: [ :create ]

    post "/login", to: "sessions#create"

    post "/password/forgot", to: "password#forgot"
  end
end
