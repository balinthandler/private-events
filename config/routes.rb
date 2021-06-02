Rails.application.routes.draw do
  root "events#index"

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: :show
  resources :events do
    member do
      get 'enroll'
      get 'cancel'
    end
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
