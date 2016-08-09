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


  #market

  get 'world_zoom/:x/:y/market/', to: 'market#home', as: 'market'
  match 'market/create_offer/', to: 'market#create', as: 'create_offer', via: :post
  get 'market/delete_offer/:id', to: 'market#delete', as: 'delete_offer'
  get 'market/accept_offer/:id', to: 'market#accept_offer', as: 'accept_offer'

  get 'market/offers', to: 'market#offers'
  get 'market/new_offer', to: 'market#new_offer'
  get 'market/my_offers', to: 'market#my_offers'
  get 'market/moves', to: 'market#moves'



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

  get 'ranking', to: 'ranking#general'
  get 'ranking/territories', to: 'ranking#territories'

  #reports

  get '/reports', to: 'report#home'
  get '/reports/market', to: 'report#market'


end
