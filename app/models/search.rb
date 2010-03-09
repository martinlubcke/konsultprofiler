class Search < ActiveRecord::Base
  has_many :requirements, :dependent => :destroy
  has_many :skills, :through => :requirements

  accepts_nested_attributes_for :requirements, :allow_destroy => true
  
  def compulsory_skills_ids
    @compulsory_skills_ids ||= requirements.select {|r| r.value == 5}.collect {|r| r.skill_id}
  end
end
