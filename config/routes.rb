Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  resources :users
  root 'users#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
