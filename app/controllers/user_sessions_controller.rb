class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
   end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:notice] = "Välkommen #{current_profile ? current_profile.first_name : current_user.name}."
      acquired_page = session[:acquired_page]
      session[:acquired_page] = nil
      redirect_to acquired_page || root_url
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = 'Nu har du loggat ut.'
    redirect_to root_url
  end
end
