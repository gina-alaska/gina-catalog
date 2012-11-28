NSCatalog::Application.routes.draw do
  resources :contact_infos

  resources :use_agreements

  resources :repos

  resources :data_types

  resources :iso_topics

  resources :feedback
  resources :geokeywords

  resources :videos
  resources :links

  resources :projects
  resources :assets, :as => :dataasset
  resources :agencies
  resources :people

  resource :catalog do
    post :search
  end

   
  match '/admin' => 'admin#index', as: 'admin'
  namespace :admin do
    resources :users
    resources :roles
    resources :assets
  end

  resources :sds, :as => 'secure_data' do
    get :use_agreement, :on => :member
    get :contactinfo, :on => :member
    get :download, :on => :member
    get :reset, :on => :collection
  end
  
  match '/sds_admin' => 'sds_admin#index', as: 'sds_admin'
  namespace :sds_admin do
    resources :contact_infos
    resources :use_agreements
    resources :assets do
      get "add_download_url", on: :member
      resources :download_urls
    end
  end

  # Omniauth pure
  match "/login" => redirect('/auth/gina')
  match "/logout" => "services#signout"
  match "/signin" => redirect('/auth/gina')
  match "/signout" => "services#signout"

  match '/auth/:service/callback' => 'services#create' 
  match '/auth/failure' => 'services#failure'

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  resources :users, :only => [:index] do
    collection do
      get :preferences
    end
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  mount Resque::Server.new, :at => '/resque'

  match '/preferences(.:format)' => 'users#preferences'
  match '/login' => 'sessions#new'
  match '/logout' => 'sessions#destroy'
  match '/search(.:format)' => 'catalog#search'
  match '/data(.:format)' => 'catalog#search'
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
