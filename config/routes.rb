DiabeticToolbox::Engine.routes.draw do
  # App home.
  root 'welcome#start'

  # Authentication routes
  get    '/member/sign_in',  to: 'member_sessions#new'
  post   '/member/sign_in',  to: 'member_sessions#create'
  delete '/member/sign_out', to: 'member_sessions#destroy'

  # Members self-management
  get    '/register',         to: 'members#new',            as: :new_member
  post   '/register',         to: 'members#create',         as: :create_member
  get    '/member/:id',       to: 'members#show',           as: :show_member
  get    '/me/:id',           to: 'members#edit',           as: :edit_member
  put    '/me/:id',           to: 'members#update',         as: :update_member
  delete '/member/delete',    to: 'members#destroy',        as: :delete_member
  get    '/dash/:id',         to: 'members#dash',           as: :member_dash
  get    '/member/delete',    to: 'members#confirm_delete', as: :member_delete_confirmation
  # resources :members

end
