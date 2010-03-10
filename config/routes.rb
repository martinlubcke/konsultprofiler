ActionController::Routing::Routes.draw do |map|
  map.resources :searches, :except => :show
  map.resources :profiles
  map.resources :skills

  map.root :controller => :profiles
end
