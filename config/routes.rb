Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'app' => 'app#index'
  get 'app/:id' => 'app#continue'
  post '/build/new' => 'build#new'
  resources :templates, only: [:index, :show, :destroy]
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

end
