class Search < ActiveRecord::Base
  has_many :requirements, :dependent => :destroy
  has_many :skills, :through => :requirements

  accepts_nested_attributes_for :requirements, :allow_destroy => true
  
  def result
    @result ||= find_result
  end
  
  def find_result
    if requirements.empty?
      Profile.all :conditions => free_text_conditions
    else
      compulsory = requirements.select {|r| r.value == 5}.collect {|r| r.skill_id}
      Profile.all( 
        :include => :rankings,
        :joins => "JOIN rankings ON rankings.profile_id = profiles.id JOIN requirements ON requirements.skill_id = rankings.skill_id AND requirements.search_id = #{id}", 
        :select => "profiles.*, SUM(rankings.value * requirements.value) as ranking_value, SUM(#{count_if_included compulsory}) as compulsory_count", 
        :conditions => free_text_conditions,
        :group => "profiles.id HAVING compulsory_count = #{compulsory.size}", 
        :order => "ranking_value DESC")
    end
  end
  
  def free_text_conditions
    words = free_text.to_s.scan(/\w+|\".+\"/).collect {|w| w.gsub('"', '')}.uniq.collect{|s| "%#{s}%"}
    [words.collect {'description LIKE ?'}.join(' OR ')] + words
  end
  
  def count_if_included coll
    if coll.empty?
      0
    else
      "CASE WHEN rankings.skill_id IN (#{coll.join(',')}) THEN 1 ELSE 0 END"
    end
  end
  
  def presentation
    '"' + free_text.to_s + '" (' + skills.collect {|s| s.name}.sort.join(', ') + ')'
  end
end
