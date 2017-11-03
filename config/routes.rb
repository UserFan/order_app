Rails.application.routes.draw do


  #devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :users, controllers: { registrations: 'users' }
  resources :users

  match '/catalog', to: 'pages#catalog', via: 'get'

  #resources :positions
  scope 'catalog' do
    resources :positions
    resources :shops
    resources :types
    resources :categories
    resources :statuses
  end

  resources :orders



  root  'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
