Nyanlog::Application.routes.draw do


  resources :app_settings
  # sites
  get "sites/:id/theme_list" , :to => "sites#theme_list#:id"
  put "sites/:id/select_theme" , :to => "sites#select_theme#:id"
  resources :sites
  # 
  resources :users
  
#  get "app_settings", :to => "app_settings#index"
#  get "app_settings/:id/edit", :to => "app_settings#edit#:id"
#  get "app_settings/new", :to => "app_settings#edit"
#  put "app_settings/:id", :to => "app_settings#update#:id"
#  post "app_settings", :to => "app_settings#create"

#    match '' => 'sites#index'
#    match 'index' => 'sites#index'
  get "user_sessions", :to => "user_sessions#new"
  post "user_sessions", :to => "user_sessions#create"
  get "user_sessions/destroy", :to => "user_sessions#destroy"

  # page_design
  get ":site/:folder/page_design/header" , :to => 'page_design#header#:site#:folder'
  get ":site/:folder/page_design/background" , :to => 'page_design#background#:site#:folder'
  get ":site/:folder/page_design/html_css" , :to => 'page_design#html_css#:site#:folder'
  get ":site/page_design/header" , :to => 'page_design#header#:site'
  get ":site/page_design/background" , :to => 'page_design#background#:site'
  get ":site/page_design/html_css" , :to => 'page_design#html_css#:site'
  put ":site/page_design" , :to => 'page_design#update#:site'
  put ":site/:folder/page_design" , :to => 'page_design#update#:site#:folder'
  post ":site/page_design" , :to => 'page_design#update#:site'
  post ":site/:folder/page_design" , :to => 'page_design#update#:site#:folder'
  get ":site/:folder/page_design/header_image" , :to => 'page_design#header_image#:site#:folder'
  get ":site/:folder/page_design/background_image" , :to => 'page_design#background_image#:site#:folder'
  get ":site/page_design/header_image" , :to => 'page_design#header_image#:site'
  get ":site/page_design/background_image" , :to => 'page_design#background_image#:site'
  put ":site/:folder/page_design/delete_header_image" , 
        :to => 'page_design#delete_header_image#:site#:folder'
  put ":site/:folder/page_design/delete_background_image" , 
        :to => 'page_design#delete_background_image#:site#:folder'
  put ":site/page_design/delete_header_image" , :to => 'page_design#delete_header_image#:site'
  put ":site/page_design/delete_background_image" , :to => 'page_design#delete_background_image#:site'


  # widget set
  get ":site/widget_sets/new" , :to => 'widget_sets#new#:site'
  get ":site/widget_sets/list" , :to => 'widget_sets#list#:site'
  get ":site/widget_sets/:id/edit" , :to => 'widget_sets#edit#:site#:id'
  put ":site/widget_sets/:id" , :to => 'widget_sets#update#:site#:id'
  post ":site/widget_sets" , :to => 'widget_sets#create#:site'
  delete ":site/widget_sets/:id" , :to => 'widget_sets#destroy#:site#:id'
  get ":site/widget_sets" , :to => 'widget_sets#index#:site'
  
  # widget element set
  post ":site/widget_set_elements/:widget_set" , 
        :to => 'widget_set_elements#create#:site#:widget_set'
  delete ":site/widget_set_elements/:id" , 
        :to => 'widget_set_elements#destroy#:site#:id'
  get ":site/widget_set_elements/edit/:id" , 
        :to => 'widget_set_elements#edit#:site#:id'
  get ":site/widget_set_elements/:widget_set" , 
        :to => 'widget_set_elements#index#:site#:widget_set'
  get ":site/widget_set_elements/selected_list/:widget_set" , 
        :to => 'widget_set_elements#selected_list#:site#:widget_set'
  put ":site/widget_set_elements/sort/:widget_set"  , 
        :to => 'widget_set_elements#sort#:site#:widget_set'
  put ":site/widget_set_elements/:id/move_behind" , 
        :to => 'widget_set_elements#move_behind#:site#:id'
  put ":site/widget_set_elements/:id/move_ahead" , 
        :to => 'widget_set_elements#move_ahead#:site#:id'

  AppConfig::Widget.array.each do |widget|
    get ":site/#{widget.name.underscore}/:id/edit", 
        :to => "#{widget.name.underscore}#edit#:site#:id"
    put ":site/#{widget.name.underscore}/:id", 
        :to => "#{widget.name.underscore}#update#:site#:id"
  end

  # folders
  get ":site/folders/new" , :to => 'folders#new#:site'
  get ":site/folders/list" , :to => 'folders#list#:site'
  get ":site/folders/:name/edit" , :to => 'folders#edit#:site#:name'
  put ":site/folders/:name" , :to => 'folders#update#:site#:name'
  post ":site/folders" , :to => 'folders#create#:site'
  delete ":site/folders/:name" , :to => 'folders#destroy#:site'
  get ":site" , :to => 'folders#index#:site'
  get ":site/folders/:name/theme_list" , :to => "folders#theme_list#:site#:name"
  put ":site/folders/:name/select_theme" , :to => "folders#select_theme#:site#:name"


  # articles
  get ":site/:folder/new" , :to => 'articles#new#:site#:folder'
  get ":site/:folder/list" , :to => 'articles#list#:site#:folder'
  put ":site/:folder/:id/move_behind" , :to => 'articles#move_behind#:site#:folder#:id'
  put ":site/:folder/:id/move_ahead" , :to => 'articles#move_ahead#:site#:folder#:id'
  get ":site/:folder/:id/edit" , :to => 'articles#edit#:site#:folder#:id'
  get ":site/:folder/:id/show" , :to => 'articles#show#:site#:folder#:id'
  get ":site/:folder/:year/:month/month" , :to => 'articles#month#:site#:folder#:year#:month',
                                  :constraints => {:year => /\d{4}/,:month => /\d{1,2}/ }
  put ":site/:folder/:id" , :to => 'articles#update#:site#:folder#:id'
  post ":site/:folder" , :to => 'articles#create#:site#:folder'
  delete ":site/:folder/:id" , :to => 'articles#destroy#:site#:id'
  get ":site/:folder" , :to => 'articles#index#:site#:folder'

  # images
  get ":site/:folder/images/new" , :to => 'images#new#:site#:folder'
  get ":site/:folder/images/selection_list" , :to => 'images#selection_list#:site#:folder'
  get ":site/:folder/images/list" , :to => 'images#list#:site#:folder'
  get ":site/images/selection_list" , :to => 'images#selection_list#:site'
  get ":site/:folder/images/:id/edit" , :to => 'images#edit#:site#:folder#:id'
  get ":site/:folder/images/:id/:style" , :to => 'images#show#:site#:folder#:id#:style'
  get ":site/:folder/images/:id" , :to => 'images#show#:site#:folder#:id'
  put ":site/:folder/images/:id/move_behind" , :to => 'images#move_behind#:site#:folder#:id'
  put ":site/:folder/images/:id/move_ahead" , :to => 'images#move_ahead#:site#:folder#:id'
  put ":site/:folder/images/:id" , :to => 'images#update#:site#:folder#:id'
  post ":site/:folder/images" , :to => 'images#create#:site#:folder'
  delete ":site/:folder/images/:id" , :to => 'images#destroy#:site#:id'
  get ":site/:folder/images" , :to => 'images#index#:site#:folder'

  # menu_items
  get ":site/menu_items/:menu_type/new" , :to => 'menu_items#new#:site#:menu_type'
  get ":site/menu_items/:menu_type/:id/edit" , :to => 'menu_items#edit#:site#:menu_type#:id'
  post ":site/menu_items/:menu_type" , :to => 'menu_items#create#:site#:menu_type'
  put ":site/menu_items/:menu_type/:id" , :to => 'menu_items#update#:site#:menu_type#:id'
  delete ":site/menu_items/:menu_type/:id" , :to => 'menu_items#destroy#:site#:menu_type#:id'
  put ":site/menu_items/:menu_type/:id/move_behind" , 
        :to => 'menu_items#move_behind#:site#:menu_type#:id'
  put ":site/menu_items/:menu_type/:id/move_ahead" , 
        :to => 'menu_items#move_ahead#:site#:menu_type#:id'
  get ":site/menu_items/:menu_type/:parent_id" , 
        :to => 'menu_items#index#:site#:menu_type#:parent_id'
  get ":site/menu_items/:menu_type" , :to => 'menu_items#index#:site#:menu_type'

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
  root :to => 'sites#default'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
