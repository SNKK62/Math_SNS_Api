Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1, format: 'json' do
      resources :users do
        member do
          get :followings, :followers
          get :show_image
          get '/problems/:times', to: 'problems#user_problem'
          get '/solutions/:times', to: 'solutions#user_solution'
        end
        collection do
          get '/search/:times/:name', to: 'users#search'
          get '/search/:times', to: 'users#search_none'
          post '/follow/:id', to: 'relationships#create'
          delete '/unfollow/:id', to: 'relationships#destroy'
          get '/iffollow/:id', to: 'relationships#iffollow'
          get '/like_problems/:times', to: 'users#like_problems'
          get '/like_solutions/:times', to: 'users#like_solutions'
        end
      end
      resources :problems, except: [:index] do 
        member do 
          post '/like', to: 'likes#problem_create'
          delete '/unlike', to: 'likes#problem_destroy'
          get '/iflike', to: 'likes#ifplike'
          resources :solutions, only: [:create] do
            collection do
              get '/:times', to: 'solutions#search'
            end
          end
          get '/comments/:times', to: 'comments#search_from_problem'
          post '/comments/', to: 'comments#problem_create'
        end
        collection do
          get '/search/:times/:category', to: 'problems#search'
          get '/search/:times', to: 'problems#search_none'
        end
      end
      resources :solutions, except: [:create] do 
        member do 
          post '/comments/', to: 'comments#solution_create'
          get '/comments/:times', to: 'comments#search_from_solution'
          post '/like', to: 'likes#solution_create'
          delete '/unlike', to: 'likes#solution_destroy'
          get '/iflike', to: 'likes#ifslike'
        end
      end
      resources :comments, except: [:create]


      resources :relationships, only: [:create, :destroy]
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      get '/logged_in', to: 'users#logged_in'
    end
  end

end
