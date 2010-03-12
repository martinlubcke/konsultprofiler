# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  def authenticate level = :any_user 
    unless params[:format] == 'pdf'
      authenticate_or_request_with_http_basic 'Konsultprofiler' do |login, password|
        set_user(login, password, level)
      end
    end
  end
  
  def authenticate_with_id
    authenticate params[:id]
  end
  
  def authenticate_admin
    authenticate :admin
  end

  def set_user login=nil, password=nil, level=:any_user
    if login == 'admin' && password == 'apa'
      session[:user] = login
      session[:user_name] = "Administratör"
      return true
    elsif login && (p = Profile.find_by_login(login)) && p.encrypted_password == password && (level == :any_user || level == p.munged_name)
      session[:user] = login
      session[:user_name] = p.name
      return true
    end
    session[:user] = nil
    session[:user_name] = nil
    return false
  end
end
