Rails.application.routes.draw do
  resources :pokemon, only: [:index, :destroy] do
    collection do
      get :import
      post :import 
      get :captured
    end
    member do
      post :capture
    end
  end
end
