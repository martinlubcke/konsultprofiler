class UsersController < ApplicationController
  before_filter :authenticate_admin 
  
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
    
    if @user.save
      redirect_to(:action => :index)
    else
      render :action => "new" 
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(users_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end
end
