Rails.application.routes.draw do
  resources :nominations
  resources :tags
  resources :subjects
  resources :bills
  resources :positions
  resources :votes
  resources :members
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/hello', to: 'application#hello_world'

  get '/members', to: 'member#index'

  get '/:chamber/:year/:month/members/:page', to: 'members#get_month'
  get '/:chamber/:year/:month/votes/:page', to: 'votes#get_month'
  get '/vote_count', to: 'votes#vote_count'
end
