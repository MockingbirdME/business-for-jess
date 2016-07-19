Rails.application.routes.draw do



  get 'appointments/new'

  get 'appointments/show'

  get 'appointments/index'

  get 'appointments/edit'

  devise_for :users
  resources :messages, only: [:index, :new, :create]
  resources :users, only: [:show] do
    resources :pets, only: [:new, :create, :edit, :update]
    resources :appointments, only: [:new, :create, :edit, :update]
  resources :appointments, only: [:index, :show, :destroy]  
  end
  get 'faq' => 'welcome#faq'
  get 'services' => 'welcome#services'
  get 'contact_us' => 'welcome#contact_us'
  root 'welcome#index'
end
