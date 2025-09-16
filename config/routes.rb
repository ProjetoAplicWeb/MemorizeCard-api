Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "decks", to: "decks#index"
  get "decks/:id", to: "decks#show"
  post "decks", to: "decks#create"
  patch "decks/:id", to: "decks#update"
  delete "decks/:id", to: "decks#destroy"

  get "decks/:id/cards", to: "cards#index"
  post "decks/:id/cards", to: "cards#create"
  delete "decks/:deck_id/cards/:card_id", to: "cards#destroy"
  post "cards/:id/done", to: "cards#done"
end
