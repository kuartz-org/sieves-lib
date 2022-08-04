Rails.application.routes.draw do
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("/projects")

  mount Sieves::Engine, at: "sieves"
end
