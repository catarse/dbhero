Dbhero::Engine.routes.draw do
  root to: "dataclips#index"
  resources :dataclips
end
