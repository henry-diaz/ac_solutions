AcSolutions::Application.routes.draw do
  devise_for :users, {
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'secret',
      sign_up: 'register'
    }
  }
  resources :purchases do
    resources :items, :only => [:create, :edit, :update, :destroy]
    member do
      get 'search_by_code'
      get 'search_by_name'
    end
  end
  resources :sales do
    resources :items, :only => [:create, :edit, :update, :destroy]
    member do
      get 'search_by_code'
      get 'search_by_name'
    end
  end
  resources :members, except: [:show]
  resources :reports, only: [:index] do
    collection do
      get 'inventories'
      get 'sales'
      get 'purchases'
      get 'export_inventories'
      get 'export_sales'
      get 'export_purchases'
      get 'tokenize_customers'
      get 'tokenize_skus'
      get 'tokenize_services'
    end
  end
  resources :settings
  resources :appointments
  resources :customers do
    resources :contacts, except: [:index, :show, :new, :destroy]
    collection do
      get 'find_customers'
    end
  end
  resources :skus, except: [:destroy] do
    member do
      get 'toggle'
    end
  end
  resources :services, except: [:destroy] do
    member do
      get 'toggle'
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  root :to => 'home#index'
end
