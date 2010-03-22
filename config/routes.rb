ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resources :searches, :except => :show
  map.resources :profiles
  map.resources :skills
  map.skill_selector 'skill_selector', :controller => :skills, :action => :selector
  map.login 'login', :controller => :user_sessions, :action => :new
  map.logout 'logout', :controller => :user_sessions, :action => :destroy
  map.pdf ':id.pdf', :controller => :profiles, :action => :show, :format => 'pdf'
  map.find_user 'find_user', :controller => :users, :action => :find
  map.find_user_result 'find_user_result', :controller => :users, :action => :find_result
  map.edit_from_document ':controller/:id/edit_from_document', :action => :edit_from_document 
  map.update_from_document ':controller/:id/update_from_document', :action => :update_from_document 
  
  map.root :controller => :profiles
end
