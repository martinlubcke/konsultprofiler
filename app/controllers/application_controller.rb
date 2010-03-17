# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password
  filter_parameter_logging :password_confirmation
  
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
    current_user && current_user.is_admin
  end
  
  def authenticate
    force_login unless current_user
  end
  
  def authenticate_pdf
    authenticate unless params[:format] == 'pdf' 
  end
  
  def authenticate_admin
    force_login unless admin?
  end

  def authenticate_admin_or_profile_owner
    force_login unless admin? || owner?(current_profile)     
  end
  
  def authenticate_admin_or_user_owner
    force_login unless admin? || owner?(current_user)     
  end
  
  def owner? item
    current_user && [current_user.munged_name, item.id.to_s].include?(params[:id])
  end
  
  def force_login
    flash[:notice] = "Du har inte befogenheter att se den sidan."
    session[:acquired_page] = request.request_uri
    redirect_to login_path
  end
end
