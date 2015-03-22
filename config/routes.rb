Dbhero::Engine.routes.draw do
  root to: "dataclips#index"
  resources :dataclips do
    get :drive, on: :collection
  end
end
