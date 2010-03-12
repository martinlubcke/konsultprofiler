# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user
  helper_method :current_profile
  helper_method :admin?
  
  private
  def current_user_session
    return @current_user if defined?(@current_user)
    @current_user = UserSession.find
  end
  
  def current_user
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = current_user_session && current_user_session.record
  end

  def current_profile
    return @current_profile if defined?(@current_profile)
    @current_profile = current_user && current_user.profile
  end
  
  def admin?
    current_user && current_user.login == 'admin'
  end
  
  def authenticate
    force_login unless current_user
  end
  
  def authenticate_admin
    force_login unless admin?
  end

  def authenticate_admin_or_profile_owner
    force_login unless admin? || current_profile && [current_profile.munged_name, current_profile.id.to_s].include?(params[:id])    
  end
  
  def force_login
    flash[:notice] = "Du har inte befogenheter att se den sidan."
    session[:acquired_page] = request.request_uri
    redirect_to login_path
  end
end
