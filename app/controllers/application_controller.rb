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
    redirect_to(login_path) unless current_user
  end
  
  def authenticate_admin
    redirect_to(login_path) unless admin?
  end

  def authenticate_admin_or_profile_owner
    redirect_to(login_path) unless admin? || current_profile && [current_profile.munged_name, current_profile.id].include?(params[:id])    
  end
end
