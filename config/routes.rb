Rails.application.routes.draw do

  root 'visitors#home'

  #user

  match '/register', to: 'user#post_register', via: :post
  match '/login', to: 'user#post_login', via: :post
  match '/logout', to: 'user#logout', via: :get
  match '/player/:user_login', to: 'user#profile', via: :get, as: 'user_profile'


  #world

  get 'world'            => 'world#world'
  get 'world_zoom'       => 'world#world_zoom'
  get 'world_zoom/:x/:y', to: 'world#world_zoom', as: 'world_zoom_c'
  get 'world/:id'        => 'world#world_terrian'

  get 'world_zoom/:x/:y/build/:building_code', to: 'world#build', as: 'build'
  get 'world_zoom/:x/:y/to_grass/', to: 'world#to_grass', as: 'to_grass'
  get 'world_zoom/:x/:y/building_destroy/', to: 'world#building_destroy', as: 'building_destroy'

  #villager

  get '/villager/:cell_id/:villager', to: 'world#villager'
  get '/villager/:cell_id/:villager/:target_cell_id', to: 'world#villager_action'
  get '/villager/new', to: 'world#new_villager', as: 'new_villager'

  #terrain

  get '/cell_actions/:cell_id', to: 'world#cell_actions'

  #admin

  get '/admin',             to: 'admin#home'
  get '/admin/reset_world', to: 'admin#reset_world'


  #ranking

  get 'ranking/general'
  get 'ranking', to: 'ranking#general'


end
