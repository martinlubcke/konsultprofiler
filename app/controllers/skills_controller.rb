class SkillsController < ApplicationController
  def index
    @skills = Skill.all :include => :category
  end

  def new
    @skill = Skill.new
    @categories = SkillCategory.all :order => :name
  end

  def edit
    @skill = Skill.find(params[:id])
    @categories = SkillCategory.all :order => :name
  end

  def create
    @skill = Skill.new(params[:skill])
    
    if @skill.save
      redirect_to(:action => :index)
    else
      render :action => "new" 
    end
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update_attributes(params[:skill])
      redirect_to(skills_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    redirect_to(skills_url)
  end
  
  def selector
    render :text => help.options_for_select(SkillCategory.find(params[:category_id]).skills.collect {|s| [s.name, s.id]})
  end
  
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::FormOptionsHelper
  end
end
