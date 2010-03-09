ActionController::Routing::Routes.draw do |map|
  map.resources :searches
  map.resources :profiles
  map.resources :skills

  map.root :controller => :profiles
end
