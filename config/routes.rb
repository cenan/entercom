Rails.application.routes.draw do
  devise_for :users
  resources :posts
  
  get 'setup' => 'main#setup'
  post 'verify_admin' => 'main#verify_admin', as: :verify_admin

  get 'download_support' => 'main#download_support', as: :download_support
  post 'import' => 'main#import', as: :import
  get 'export' => 'main#export', as: :export

  get 'main/error_500', as: :error_test

  root to: "main#index"
end
