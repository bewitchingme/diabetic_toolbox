DiabeticToolbox::Engine.routes.draw do
  # App home.
  root 'welcome#start'

  # Static Pages
  get '/about', to: 'welcome#about', as: :about

  # Authentication routes
  get    '/member/sign_in',  to: 'member_sessions#new',               as: :sign_in
  post   '/member/sign_in',  to: 'member_sessions#create',            as: :begin_session
  delete '/member/sign_out', to: 'member_sessions#destroy',           as: :sign_out
  get    '/member/recover',  to: 'member_sessions#password_recovery', as: :password_recovery
  post   '/member/recover',  to: 'member_sessions#send_recovery_kit', as: :recovery_kit

  # Members self-management
  get    '/register',              to: 'members#new',            as: :new_member
  post   '/register',              to: 'members#create',         as: :create_member
  get    '/members/:id',           to: 'members#show',           as: :show_member
  get    '/me/:id',                to: 'members#edit',           as: :edit_member
  match  '/me/:id',                to: 'members#update',         as: :update_member, via: [:patch, :put]
  get    '/dash',                  to: 'members#dash',           as: :member_dashboard
  delete '/membership/cancel/:id', to: 'members#destroy',        as: :destroy_member
  get    '/membership/cancel',     to: 'members#confirm_delete', as: :last_chance

  # Settings for members
  get    '/setup',    to: 'settings#new',    as: :setup
  post   '/setup',    to: 'settings#create', as: :create_setting
  get    '/settings', to: 'settings#edit',   as: :settings
  match  '/settings', to: 'settings#update', as: :update_settings, via: [:patch, :put]

end
