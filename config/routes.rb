DiabeticToolbox::Engine.routes.draw do
  # :enddoc:
  #region Static
  root 'welcome#start'

  get '/about', to: 'welcome#about', as: :about
  #endregion

  #region Authentication
  get    '/sign_in',          to: 'member_sessions#new',               as: :sign_in
  post   '/sign_in',          to: 'member_sessions#create',            as: :begin_session
  delete '/sign_out',         to: 'member_sessions#destroy',           as: :sign_out
  get    '/request_recovery', to: 'member_sessions#password_recovery', as: :password_recovery
  post   '/request_recovery', to: 'member_sessions#send_recovery_kit', as: :recovery_kit
  get    '/recover/:token',   to: 'member_sessions#recover',           as: :recover_membership
  post   '/recover/:token',   to: 'member_sessions#release',           as: :release_membership
  get    '/change_email',     to: 'member_sessions#edit_email',        as: :edit_member_email
  match  '/change_email',     to: 'member_sessions#update_email',      as: :update_member_email, via: [:patch, :put]
  get    '/reconfirm/:token', to: 'member_sessions#reconfirm',         as: :reconfirmation
  #endregion

  #region Members Self-Management
  get    '/register',          to: 'members#new',            as: :new_member
  post   '/register',          to: 'members#create',         as: :create_member
  get    '/members/:id',       to: 'members#show',           as: :show_member
  get    '/me',                to: 'members#edit',           as: :edit_member
  match  '/me',                to: 'members#update',         as: :update_member, via: [:patch, :put]
  get    '/dash',              to: 'members#dash',           as: :member_dashboard
  delete '/membership/cancel', to: 'members#destroy',        as: :destroy_member
  get    '/membership/cancel', to: 'members#confirm_delete', as: :last_chance
  #endregion

  #region Settings for members
  get    '/setup',    to: 'settings#new',    as: :setup
  post   '/setup',    to: 'settings#create', as: :create_setting
  get    '/settings', to: 'settings#edit',   as: :settings
  match  '/settings', to: 'settings#update', as: :update_settings, via: [:patch, :put]
  #endregion

  #region Readings for members
  get  '/readings', to: 'readings#index',  as: :list_readings
  get  '/record',   to: 'readings#new',    as: :record_reading
  post '/record',   to: 'readings#create', as: :create_reading
  #endregion

  #region Recipes
  get    '/recipes',             to: 'recipes#index',    as: :recipes
  get    '/recipes/add',         to: 'recipes#new',      as: :new_recipe
  post   '/recipes/add',         to: 'recipes#create',   as: :create_recipe
  get    '/recipe/:id',          to: 'recipes#show',     as: :show_recipe
  get    '/recipe/edit/:id',     to: 'recipes#edit',     as: :edit_recipe
  match  '/recipe/edit/:id',     to: 'recipes#update',   as: :update_recipe,   via: [:patch, :put]
  match  '/recipe/:id/finalize', to: 'recipes#finalize', as: :finalize_recipe, via: [:patch, :put]
  delete '/recipe/:id/delete',   to: 'recipes#destroy',  as: :delete_recipe
  #endregion
end
