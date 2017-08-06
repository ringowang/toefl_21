Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'words#index'
  resources :words, only: [:index, :show] do
    put :remember, on: :member
    put :not_remember, on: :member
  end
end
