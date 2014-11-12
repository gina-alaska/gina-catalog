Rails.application.routes.draw do

  get '/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  get '/auth/:provider/disable', to: 'users#disable_provider'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  get '/admin' => 'admin/dashboard#index', as: :admin
  get '/manager' => 'manager/dashboard#index', as: :manager
  get '/portal_not_found' => 'welcome#portal_not_found', as: :portal_not_found

  resources :sessions
  resources :memberships

  resources :users
  namespace :admin do
    resources :users
    resources :portals
    resources :entry_types
  end

  namespace :manager do
    resources :users do
      get :autocomplete, on: :collection
    end

    resources :entries do
      collection do
        get :tags
      end
    end

    resources :permissions

    resources :invitations do 
      member do
        patch :resend
        get :accept
      end
    end

    resources :contacts do
      collection do
        get :search
      end
    end

    resources :use_agreements

    resources :agencies do
      collection do
        get :search
      end
    end
    
    resources :collections
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your portal routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
