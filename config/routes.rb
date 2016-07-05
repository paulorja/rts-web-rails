Rails.application.routes.draw do

  root 'visitors#home'

  #user

  match '/register', to: 'user#post_register', via: :post
  match '/login', to: 'user#post_login', via: :post
  match '/logout', to: 'user#logout', via: :get

  #world

  #world

  get 'world'            => 'world#world'
  get 'world_zoom'       => 'world#world_zoom'
  get 'world_zoom/:x/:y', to: 'world#world_zoom', as: 'world_zoom_c'
  get 'world/:id'        => 'world#world_terrian'

  #admin

  get '/admin',             to: 'admin#home'
  get '/admin/reset_world', to: 'admin#reset_world'
end
