Rails.application.routes.draw do
  post 'users/change_status'
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index]
end
