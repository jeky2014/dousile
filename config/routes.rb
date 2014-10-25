Rails.application.routes.draw do
  
  get '/sitemap.xml' => 'articles#sitemap'
  get '/detail/(:id).html' => 'articles#pc_show'
  
  get '/articles/fa.htm' => 'articles#m_new'
  post '/articles/create/m/' => 'articles#m_create'
  get '/articles/(:id).html' => 'articles#m_show'
  get '/articles/create/m/success.htm' => 'articles#m_create_success'

  get '/admin/articles/new/:id' => 'articles#admin_new'
  get '/admin/articles/new' => 'articles#admin_new'
  get '/admin/articles/edit' => 'articles#admin_edit'
  get '/admin/articles' => 'articles#admin_list'
  get '/admin/articles/st:state' => 'articles#admin_list'
  post '/admin/articles/save' => 'articles#admin_create'
  patch '/admin/articles/save' => 'articles#admin_update'
  delete '/admin/articles/delete/:id' => 'articles#admin_delete'
    
  get '/admin/login' => 'articles#admin_login'
  post '/admin/login' => 'articles#admin_login'
  get '/admin/logout' => 'articles#admin_logout'
  
  get '/admin/upyun' => 'admin#upyun'
  
  get '/api/weixin' => 'api#weixin'
  post '/api/weixin' => 'api#weixin'
  get '/api/test' => 'api#test'
    
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'articles#index'

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
