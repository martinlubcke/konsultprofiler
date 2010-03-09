class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.xml
  def index
    @searches = Search.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.xml
  def show
    @search = Search.find(params[:id], :include => :skills)
    compulsory = @search.compulsory_skills_ids
    @profiles = Profile.find(:all, 
      :include => :rankings,
      :joins => "JOIN rankings ON rankings.profile_id = profiles.id JOIN requirements ON requirements.skill_id = rankings.skill_id AND requirements.search_id = #{@search.id}", 
      :select => "profiles.*, SUM(rankings.value * requirements.value) as ranking_value, SUM(CASE WHEN rankings.skill_id IN (#{compulsory.join(',')}) THEN 1 ELSE 0 END) as compulsory_count", 
      :group => "profiles.id HAVING compulsory_count = #{compulsory.size}", :order => "ranking_value DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search }
    end
  end
  
  def skill_hash weighted_skills
    weighted_skills.inject({}) {|h, ws| h[ws.skill] = ws.value}
  end
    
  def conditions
    ids = @search.compulsory_skills_ids
    ids.collect {|id| 'rankings.skill_id'}.join ' AND ' unless ids.empty?
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.xml
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to(@search) }
        format.xml  { render :xml => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.xml
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to(@search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.xml
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to(searches_url) }
      format.xml  { head :ok }
    end
  end
end
