Rails.application.routes.draw do
  root  'pages#home'

  post '/rate' => 'rater#create', :as => 'rate'
  #devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :users, controllers: { registrations: 'users' }
  resources :users do
    resources :employees
    get 'close_access', on: :member
  end

  match '/catalog', to: 'pages#catalog', via: 'get'

  scope ":unit" do
    resources :shops do
      get 'import_version', on: :member #format: 'json'
      get 'cash_images', on: :member, defaults: { format: :js }
      resources :service_equipments
      resources :esps do
        resources :esp_certs, only: [:new, :create, :edit, :update, :destroy]
      end
    end
  end
  scope module: :catalog do
    resources :positions
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
    resources :carrier_types
    resources :equipment_types
    resources :cost_types
    resources :type_documents
    resources :sim_cards do
      get 'sim_card_log', on: :member, defaults: { format: :js }
    end

  end

  resources :orders do
    get 'closing', on: :member
    resources :performers
  end

  resources :tasks do
    get 'closing', on: :member
    resources :task_performers
  end

  resources :executions do
    get 'coordination', on: :member
    get 'remove_control', on: :member
    resources :reworks, only: [:new, :create]
  end

  resources :task_executions do
    get 'coordination', on: :member, defaults: { format: :js }
    get 'coordination_master', on: :member
    get 'remove_control', on: :member
    resources :task_reworks, only: [:new, :create]
  end
  resources :enum_resources
  resources :roles do
    resources :template_accesses, only: [:new, :create, :edit, :update]
  end
  #resources :action_apps
  resources :enum_actions
  resources :service_equipments
  resources :cash_images, only: [:show]
  resources :esp_certs, only: [:index, :show]
  resources :report_cost_services do
    delete 'remove_service_report', on: :member
    get 'closing_report', on: :member
    get 'open_report', on: :member
    get 'report_service', on: :member
  end
  get :version_update_log, action: :version_update, controller: 'shops'
  get :export_shops, action: :export_shops, controller: 'shops'
  get :export_cert_xls, action: :export_xls, controller: 'esp_certs'
  get :system_user, action: :system_user, controller: 'users'
  get :access_list, action: :access_list, controller: 'users'
  get 'user_open_access/:id', to: 'users#edit_open_user_access', as: :edit_open_access
  patch 'user_open_access/:id', to: 'users#open_user_access', as: :open_access
  resources :version_update_logs, only: [:index]
end
