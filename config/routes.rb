Nyanlog::Application.routes.draw do


#    match '' => 'sites#index'
#    match 'index' => 'sites#index'
    
  get "user_sessions/new"
  get "user_sessions/create"
    
    
  resources :sites do
  end

  # folders
  get ":site/folders" , :to => 'folders#index#:site'
  get ":site/folders/new" , :to => 'folders#new#:site'
  get ":site/folders/list" , :to => 'folders#list#:site'
  get ":site/folders/:name/edit" , :to => 'folders#edit#:site#:name'
  put ":site/folders/:name" , :to => 'folders#update#:site#:name'
  post ":site/folders" , :to => 'folders#create#:site'
  delete ":site/folders/:name" , :to => 'folders#destroy#:site'

  # articles
  get ":site/:folder" , :to => 'articles#index#:site#:folder'
  get ":site/:folder/new" , :to => 'articles#new#:site#:folder'
  get ":site/:folder/list" , :to => 'articles#list#:site#:folder'
  get ":site/:folder/:id/edit" , :to => 'articles#edit#:site#:folder#:id'
  put ":site/:folder/:id" , :to => 'articles#update#:site#:folder#:id'
  post ":site/:folder" , :to => 'articles#create#:site#:folder'
  delete ":site/:folder/:id" , :to => 'articles#destroy#:site#:id'

  
  #resources :folders do
  #  member do
  #    get "/:site/folders/new" , :to => 'folders#new#:site'
  #  end
  #end

    
#  get "sites", :to => 'sites#index'
#  get "sites/index", :to => 'sites#index'
#  get "sites/edit/:id", :to => 'sites#edit#:id'
#  get "sites/new"
#  post "sites/create"
#  put "sites/:id/update", :to => 'sites#update#:id'
#  get "sites/show"
#  delete "sites/destroy/:id", :to => 'sites#destroy#:id'


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
