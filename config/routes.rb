require 'resque_web'

Rails.application.routes.draw do
  apipie
  scope module: :web do
    root to: 'welcome#index'
    get '*subroute', to: 'welcome#index', constraints: { subroute: /(?!admin|apipie|api|login|logout|resque_web).*/ }

    resource :session, only: [:new, :create, :destroy]
    get :login, to: 'sessions#new'
    post :login, to: 'sessions#create', as: :create_session
    get :logout, to: 'sessions#destroy'

    namespace :admin do
      root to: 'welcome#index'

      resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :streets, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :houses, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :apartments, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :meters, only: [:index, :show]
      resources :meter_indications, only: [:index]
      resources :services, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :tariffs, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :claims, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :appeals, only: [:index, :edit, :update, :destroy]
      resources :accounts, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end

  namespace :api do
    namespace :v1 do
      resource :session, only: [:create]
      resources :users, only: [:create]
      resources :meter_indications, only: [:create]

      namespace :user do
        resources :meters, only: [:index]
        get 'meters/:kind', to: 'meters#show', as: :meters_details
        resources :appeals, only: [:index, :show, :create]
        resources :tariffs, only: [:index]
        resources :claims, only: [:index, :create]
        resources :services, only: [:index]
        resource :profile, only: [:show, :update]
        resource :account, only: [:show]
      end

      namespace :manager do
        resources :meters do
          collection do
            get :houses_data
            get :apartments_data
            get :apartment_details
            get 'apartment_details_by_service/:service', to: 'meters#apartment_details_by_service', as: :apartment_service_details
          end
        end
        resources :accounts, only: [:index, :create, :update, :destroy]
        resources :appeals, only: [:index, :update, :destroy]
        resources :services, only: [:index, :create, :update, :destroy]
        resources :users, only: [:index, :create, :update, :destroy]
        resources :claims, only: [:index, :create, :update, :destroy]

        resources :tariffs, only: [:index, :create, :update, :destroy] do
          collection do
            get :kinds
          end
        end

        resources :streets, only: [:index]

        resources :houses, only: [:index] do
          collection do
            get :count
          end
        end

        resources :apartments, only: [:index] do
          collection do
            get :count
          end
        end
      end
    end

    post :meter_indications, to: 'v1/meter_indications#create'
  end

  mount ResqueWeb::Engine => '/resque_web'
end
