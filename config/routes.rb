DiabeticToolbox::Engine.routes.draw do
  # App home.
  root 'welcome#start'

  # Authentication routes
  get    '/member/sign_in',  to: 'member_sessions#new'
  post   '/member/sign_in',  to: 'member_sessions#create'
  delete '/member/sign_out', to: 'member_sessions#destroy'

  # Members self-management
  resources :members

end
