NSCatalog::Application.routes.draw do
  resources :data_types

  resources :iso_topics

  resources :feedback
  resources :geokeywords

  resources :videos
  resources :links

  resources :projects
#  resources :assets
  resources :agencies
  resources :people

  resources :catalog, :constraints => { :format => /[a-z]+(\.[a-z]+)?/ } do
    get :download
    
    collection do
      post :search
      get :search
    end

    resources :locations
  end
  
  resource :session

  resources :users do
    get :preferences
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'manager' => 'manager#index'
  
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
