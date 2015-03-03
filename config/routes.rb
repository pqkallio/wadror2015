Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create_oauth'

  post 'users/new_oauth', to: 'users#create_oauth_user'

  resources :memberships do
    post 'approve_application', on: :member
  end

  resources :beer_clubs

  resources :users do
    post 'toggle_frozen', on: :member
  end

  resources :beers

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :ratings, only: [:index, :new, :create, :destroy]

  resources :places, only: [:index, :show]

  resources :styles

  resource :session, only: [:new, :create, :delete]

  root 'breweries#index'

  get 'kaikki_bisset', to: 'beers#index'

  get 'signup', to:'users#new'

  get 'signin', to:'sessions#new'

  get 'beerlist', to:'beers#list'

  get 'ngbeerlist', to:'beers#nglist'

  get 'brewerylist', to:'breweries#brewerylist'

  post 'places', to: 'places#search'

  delete 'signout', to: 'sessions#destroy'

#  get 'ratings', to: 'ratings#index'
#  get 'ratings/new', to: 'ratings#new'
#  post 'ratings', to:'ratings#create'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
