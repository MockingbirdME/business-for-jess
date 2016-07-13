Rails.application.routes.draw do


  resources :messages, only: [:index, :new, :create]

  get 'faq' => 'welcome#faq'
  get 'services' => 'welcome#services'
  get 'contact_us' => 'welcome#contact_us'
  root 'welcome#index'
end
