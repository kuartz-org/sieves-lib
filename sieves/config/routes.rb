Sieves::Engine.routes.draw do
  resources :filterables, only: [], param: :model_name do
    resource :filters, only: %i[show create], controller: "filterable/filters"
    resources :filters, only: %i[destroy], controller: "filterable/filters", param: :filter_index
  end
end
