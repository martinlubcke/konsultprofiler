class UsersController < ApplicationController
  before_filter :authenticate_admin, :except => [:find, :find_result, :show, :edit, :update, :index]
  before_filter :authenticate_admin_or_user_owner, :only => [:edit, :update]
  before_filter :authenticate, :only => [:show, :index]
  
  def index
    @all_users = params[:all]
    @users = @all_users ? User.all : User.without_profile
  end

  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    set_sensitive_info

    if @user.save
      redirect_to(:action => :index)
    else
      render :action => "new" 
    end
  end

  def update
    @user = User.find(params[:id])

    set_sensitive_info

    if @user.update_attributes(params[:user])
      redirect_to(user_url(@user))
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end
  
  def find
  end
  
  def find_result
    @search_name = params[:name].to_s 
    if @search_name == session[:last_find]
      render :text => "text to render..." and return
    end
    session[:last_find] = @search_name
    unless @search_name.empty?
      name = '%' + params[:name] + '%'
      @users = User.all :order => :last_name, :conditions => ['first_name LIKE ? OR last_name LIKE ?', name, name]
    end
  end
  
  private
  def set_sensitive_info
    u = params[:user]
    if (@user == current_user) || (admin? && !@user.is_admin)
      @user.login = u[:login] if u[:login]
      @user.password = u[:password] if u[:password]
      @user.password_confirmation = u[:password_confirmation] if u[:password_confirmation]
    end
    if current_user.is_root_admin? && !@user.is_root_admin?
      @user.is_admin = u[:is_admin] if u[:is_admin]
    end
  end
end
