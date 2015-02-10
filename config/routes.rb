NSCatalog::Application.routes.draw do
  namespace :admin do
    resources :setups
    resources :geokeywords
    resources :users
    resources :notifications
    resources :tags do
      collection do
        post :merge
      end
    end
  end
  
  namespace :manager do
    resources :uploads
    
    resources :catalogs do
      resources :repos
      resources :map_layers
      member do
        put :publish
        put :unpublish
        post :upload
        get :download
        put :share
      end
    end
    resources :csw_imports do
      member do
        post :import
        post :new_agency
        get :status
      end
    end
    resources :images do
      collection do
        post :ace_search
      end
    end
    resources :use_agreements
    resources :contact_infos
    resources :notifications
    
    resources :themes do
      member do
        put :activate
      end
    end
    
    resources :page_contents do
      get :upload_image, :on => :member
      get :add, :on => :member
      put :remove, :on => :member
      put :preview, :on => :member
      post :sort, :on => :collection
      get :global, :on => :collection
      
      resources :images, :only => [] do
        member do
          post :add
          post :remove
        end
      end
    end
    
    resources :page_snippets
    resources :page_layouts
    resource :setup

    resources :agencies do
      put :add_image, :on => :member
      collection do
        post :visible
        post :hidden
      end
      member do
        put :add_alias
      end
    end

    resources :collections do
      member do
        put :add
        delete :remove
      end
    end

    resources :contacts
    resources :roles
    resources :memberships do
      get :resend_invite, on: :member
    end

    resources :people do
      collection do
        post :visible
        post :hidden
      end
    end
  end

  resource :search do
    get :export
  end
  
  match '/manager' => 'manager#dashboard', as: 'manager'
#  match '/search' => 'search#search', as: 'search'
  match '/manager/full_contact' => 'manager/contact_infos#full_contact'
  match '/manager/links' => 'manager#links'

  resources :map_layers

  resources :contact_infos

  resources :use_agreements

  resources :data_types

  resources :iso_topics

  resources :feedbacks
  resources :geokeywords

  resources :videos
  resources :links

  # old resources
  # resources :projects
  # resources :assets
  
  resources :agencies
  # resources :people

  resource :sitemap

  resources :notifications, only: [:index] do
    post :dismiss, on: :member
  end

  resources :contacts, only: [:index, :create]
  resources :catalogs do
    get :more_info, on: :member
    resources :downloads do
      get :redirect, on: :member 
      
      member do
        get :contact_info
        get :offer
      end
    end
  end
  match '/sds/:catalog_id' => "downloads#sds"
     
  # Omniauth pure
  match "/login" => redirect('/auth/gina')
  match "/logout" => "authentications#signout"
  match "/signin" => redirect('/auth/gina')
  match "/signout" => "sessions#signout"
  match "/sessions/test" => "sessions#test"

  match '/auth/:service/callback' => 'sessions#create' 
  match '/auth/failure' => 'sessions#failure'
  
  match '/cms/media/:size/*id(.:format)' => Dragonfly.app.endpoint { |params, app|
    image = app.fetch(params[:id])    
    format = params[:format] || 'jpg'
    
    begin
      unless image.image?
        image = app.fetch_file(Rails.root.join("app/assets/images/document.png"))
      end
    rescue
      image = app.fetch_file(Rails.root.join("app/assets/images/document.png"))
    end

    image = image.thumb(params[:size])
    image = image.encode(params[:format]) if image.format.to_s != format
    image
  }, as: :cms_media
  
  match '/cms/thumbnail/:size/:id(.:format)' => Dragonfly.app.endpoint { |params, app|
    image = Image.where(id: params[:id]).first.try(:file) 
    format = params[:format] || 'jpg'
    
    begin
      unless image.image?
        image = app.fetch_file(Rails.root.join("app/assets/images/document.png"))
      end
    rescue
      image = app.fetch_file(Rails.root.join("app/assets/images/document.png"))
    end

    image = image.thumb(params[:size])
    image = image.encode(format) if image.format.to_s != format
    image    
  }, as: :thumb

  resources :authentications, :only => [:index, :create, :destroy] do
    collection do
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  resources :users, :only => [:index] do
    collection do
      get :toggle_beta
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

  match '/preferences(.:format)' => 'users#preferences'
#  match '/login' => 'sessions#new'
#  match '/logout' => 'sessions#destroy'

  resources :pages, only: :show do
    get :not_found, on: :collection
  end  
  
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#show", :slug => 'home'

  # See how all your routes lay out with "rake routes"
  match '*slug' => 'pages#show', as: :page

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
