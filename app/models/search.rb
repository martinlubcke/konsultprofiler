class Search < ActiveRecord::Base
  has_many :requirements, :dependent => :destroy
  has_many :skills, :through => :requirements

  accepts_nested_attributes_for :requirements, :allow_destroy => true
  
  def result
    @result ||= find_result
  end
  
  def find_result
    compulsory = requirements.select {|r| r.value == 5}.collect {|r| r.skill_id}
    Profile.find(:all, 
      :include => :rankings,
      :joins => "JOIN rankings ON rankings.profile_id = profiles.id JOIN requirements ON requirements.skill_id = rankings.skill_id AND requirements.search_id = #{id}", 
      :select => "profiles.*, SUM(rankings.value * requirements.value) as ranking_value, SUM(#{count_if_included compulsory}) as compulsory_count", 
      :group => "profiles.id HAVING compulsory_count = #{compulsory.size}", :order => "ranking_value DESC")
  end
  
  def count_if_included coll
    if coll.empty?
      0
    else
      "CASE WHEN rankings.skill_id IN (#{coll.join(',')}) THEN 1 ELSE 0 END"
    end
  end
end
