ActionController::Routing::Routes.draw do |map|
  map.resources :searches, :except => :show
  map.resources :profiles
  map.resources :skills
  map.skill_selector 'skill_selector', :controller => :skills, :action => :selector
  map.login 'login', :controller => :login

  map.root :controller => :profiles
end
