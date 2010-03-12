class ProfilesController < ApplicationController
  before_filter :authenticate_with_id, :except => [:new, :create, :destroy, :index, :show]
  before_filter :authenticate_admin, :only => [:new, :create, :destroy]
  before_filter :authenticate, :only => :show

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
  end

  def edit
    @profile = Profile.find(params[:id])
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
