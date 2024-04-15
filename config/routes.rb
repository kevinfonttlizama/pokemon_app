# config/routes.rb
Rails.application.routes.draw do
  resources :pokemons, only: [:index] do
    member do
      post 'capture'
      delete 'destroy'
    end
  end
end
