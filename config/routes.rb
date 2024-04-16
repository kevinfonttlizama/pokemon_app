# config/routes.rb
Rails.application.routes.draw do
  resources :pokemons do
    collection do
      post 'import'
    end
    member do
      post 'capture'
      delete 'release'
    end
  end
end
