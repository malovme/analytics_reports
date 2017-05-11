Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root '/', 'reports#new'

  get '/oauth', to: 'sessions#oauth'
  get '/signout', to: 'sessions#destroy'

  resources :reports
  root to: 'reports#index'

end
