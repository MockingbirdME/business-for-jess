Rails.application.routes.draw do


  devise_for :users
  resources :messages, only: [:index, :new, :create]
  resources :users, only: [:show] do
    resources :pets, only: [:new, :create, :edit, :update]
    resources :appointments, only: [:new, :destroy]
      post '/book_appointment' => 'appointments#book_appointment', as: :book_appointment
  end
  get 'faq' => 'welcome#faq'
  get 'services' => 'welcome#services'
  get 'contact_us' => 'welcome#contact_us'
  root 'welcome#index'
end
