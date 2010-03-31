class ViewsController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    @profile = Profile.find(params[:profile_id])
    @views = @profile.views
  end

  def show
    @profile = Profile.find(params[:profile_id])
    redirect_to(profile_path(@profile, :format => :pdf, :view_id => params[:id]))
  end

  def new
    @profile = Profile.find(params[:profile_id])
    @view = @profile.views.build :description => @profile.description
    @view.skills = @profile.skills
    @view.assignments = @profile.assignments
  end

  def edit
    @profile = Profile.find(params[:profile_id])
    @view = @profile.views.find(params[:id])
  end

  def create
    @profile = Profile.find(params[:profile_id])
    @view = @profile.views.build(params[:view])

    if @view.save
      flash[:notice] = 'Ny vy skapad.'
      redirect_to([@profile, @view])
    else
      render :action => "new"
    end
  end

  def update
    @profile = Profile.find(params[:profile_id])
    @view = @profile.views.find(params[:id])

    if @view.update_attributes(params[:view])
      flash[:notice] = 'Vyn ändrades utan problem.'
      redirect_to([@profile, @view])
    else
      render :action => "edit"
    end
  end

  def destroy
    @profile = Profile.find(params[:profile_id])
    @view = @profile.views.find(params[:id])
    @view.destroy

    redirect_to(views_url(@profile))
  end
end
