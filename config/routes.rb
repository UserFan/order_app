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
    resources :sim_cards
  end

  resources :orders do
    get 'closing', on: :member
  end
  resources :executions do
    get 'coordination', on: :member
    get 'remove_control',  
    resources :reworks, only: [:new, :create]
  end
  resources :cash_images, only: [:show]

  root  'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
