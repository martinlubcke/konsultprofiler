ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :searches, :except => :show
  map.resources :profiles
  map.resources :skills
  map.skill_selector 'skill_selector', :controller => :skills, :action => :selector
  map.login 'login', :controller => :user_sessions, :action => :new
  map.logout 'logout', :controller => :user_sessions, :action => :destroy

  map.root :controller => :profiles
end
