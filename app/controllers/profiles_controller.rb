class ProfilesController < ApplicationController
  before_filter :authenticate_admin, :except => [:edit, :update, :edit_from_document, :update_from_document, :show, :index]
  before_filter :authenticate_admin_or_profile_owner, :only => [:edit, :update, :edit_from_document, :update_from_document]
  before_filter :authenticate_pdf, :only => [:show]
  before_filter :authenticate, :only => [:index]
  
  def index
    @profiles = Profile.all :include => :user
  end

  def show
    @profile = Profile.find(params[:id], :include => [{:rankings => {:skill => :category}}, :assignments, :user])

    respond_to do |format|
      format.html
      format.pdf do
        if params[:view_id]
          @view = @profile.views.find(params[:view_id])
        end
      end
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
  
  def edit_from_document
    @profile = Profile.find(params[:id])
  end
  
  def update_from_document
    @profile = Profile.find(params[:id])
    @profile.add_rankings_from_text params[:skills_text] rescue @profile.errors.add_to_base('Fel vid tolkning av kompetenser')
    @profile.add_assignments_from_text params[:assignments_text] rescue @profile.errors.add_to_base('Fel vid tolkning av uppdrag')
    render :action => "edit"
  end
end
