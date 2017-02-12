Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'app' => 'app#index'
  get 'app/:id' => 'app#continue'
  post '/build/new' => 'build#new'
  resources :templates
  resources :charges
  resources :accounts, only: [:new, :create, :index]
  get 'profile' => 'profile#index'
  get 'slice/:id' => 'slice#continue'
  get 'slice' => 'slice_tool#index'
  post 'slice/new' => 'slice_tool#new'
  post 'webhook/stripe' => 'webhook#stripe'
  get 'webhook/test' => 'webhook#test_stripe_event'
  post 'account/make_admin' => 'accounts#make_admin'
  post 'account/remove_admin' => 'accounts#remove_admin'
  post 'account/remove_user' => 'accounts#remove_user_from_account'

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
