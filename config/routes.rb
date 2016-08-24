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

  get '/unit/:unit_id', to: 'world#unit'
  get '/units/move/:villager/:target_cell_id', to: 'world#move_unit'

  get '/units/new/:unit/:cell/:amount', to: 'world#new_unit', as: 'new_unit'

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
  get '/report_detail/:report_id', to: 'report#report_detail'

  # blacksmith
  get '/blacksmith', to: 'blacksmith#home'
  get '/blacksmith/:up_column', to: 'blacksmith#up_item'




end
