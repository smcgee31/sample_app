Rails.application.routes.draw do
  root "static_pages#home"
  get "users/new"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end

# using the GET paths above (ie. /about) automagically gives us both
# about_path - which would be `/about`
# about_url - which would be `http://www.example.com/about`

# using 'resources' above gives us RESTful actions from the Users controller
# first notably is the show action. ie. `/users/1` will give us the
# show action on user 1
