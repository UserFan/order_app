Rails.application.routes.draw do


  #devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :users, controllers: { registrations: 'users' }
  resources :users

  match '/catalog', to: 'pages#catalog', via: 'get'

  #resources :positions
  scope 'catalog' do
    resources :positions
    resources :shops do
      get 'import_version', on: :member
      resources :service_equipments
      resources :cost_equipments
      resources :esps do
        resources :esp_certs, only: [:new, :create, :edit, :update, :destroy]
      end
    end
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
    resources :carrier_types
    resources :equipment_types
    resources :cost_types
  end

  resources :orders do
    get 'closing', on: :member
  end
  resources :executions do
    get 'coordination', on: :member
    get 'remove_control', on: :member
    resources :reworks, only: [:new, :create]
  end
  resources :cash_images, only: [:show]
  resources :esp_certs, only: [:index, :show]
  get :version_update_log, action: :version_update, controller: 'shops'
  get :export_shops, action: :export_shops, controller: 'shops'
  get :export_cert_xls, action: :export_xls, controller: 'esp_certs'
  get :system_user, action: :system_user, controller: 'users'
  resources :version_update_logs, only: [:index]


  root  'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
