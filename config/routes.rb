Rails.application.routes.draw do


  #devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :users, controllers: { registrations: 'users' }
  resources :users

  match '/catalog', to: 'pages#catalog', via: 'get'

  #resources :positions
  scope 'catalog' do
    resources :positions
    resources :shops
    resources :cashboxes
    resources :types
    resources :categories
    resources :statuses
    resources :apcs
    resources :communications
    resources :keyboards
    resources :modems
    resources :displays
    resources :commouses
    resources :printers
    resources :providers
    resources :routers
    resources :stabilizers
    resources :weighers
    resources :scaners
    resources :system_units
    resources :bank_units
    resources :organization_units
    resources :fiscals
  end

  resources :orders



  root  'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
