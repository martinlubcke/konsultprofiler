class ProfilesController < ApplicationController
  before_filter :authenticate_admin, :except => [:edit, :update, :show, :index]
  before_filter :authenticate_admin_or_profile_owner, :only => [:edit, :update]
  before_filter :authenticate_pdf, :only => [:show]
  before_filter :authenticate, :only => [:index]
  
  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find(params[:id], :include => [{:rankings => {:skill => :category}}, :assignments])

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def new
    @profile = Profile.new
    @profile.ensure_user
  end

  def edit
    @profile = Profile.find(params[:id])
    @profile.ensure_user
  end

  def create
    @profile = Profile.new(params[:profile])

    if @profile.save
      flash[:notice] = 'Profilen skapades utan problem.'
      redirect_to(@profile)
    else
      render :action => "new"
    end
  end

  def update
    @profile = Profile.find(params[:id], :include => {:rankings => :profile})

    if @profile.update_attributes(params[:profile])
      flash[:notice] = 'Profilen uppdaterades utan problem.'
      redirect_to(@profile)
    else
      render :action => "edit"
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to(profiles_url)
  end
end
