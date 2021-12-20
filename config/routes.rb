Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1, format: 'json' do
      resources :users do
        member do
          get :followings, :followers
          get :show_image
          resources :problems, only: [:index]
        end
      end
      resources :problems, except: [:index] do 
        member do 
          resources :solutions, only: [:create]
          post '/comments/', to: 'comments#problem_create'
        end
      end
      resources :solutions, except: [:create] do 
        member do 
          post '/comments/', to: 'comments#solution_create'
        end
      end
      resources :comments, except: [:create]

      resources :relationships, only: [:create, :destroy]
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end

end
