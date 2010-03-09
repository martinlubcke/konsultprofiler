class Skill < ActiveRecord::Base
  has_many :rankings, :dependent => :destroy
  has_many :profiles, :through => :rankings
  belongs_to :category, :class_name => "SkillCategory", :foreign_key => "skill_category_id"
  has_many :requirements, :dependent => :destroy

  def self.merge_skills source_names, target_names
    targets = [*target_names].collect {|n| Skill.find_by_name n}
    sources = [*source_names].collect {|n| Skill.find_by_name n}
    return 0 unless targets.all? and sources.all?
    count = 0
    sources.each do |source|
      source.rankings.each do |ranking|
        targets.each do |target|
          target.rankings.create :value => ranking.value, :profile => ranking.profile
          count += 1
        end
      end
      source.destroy
    end
    return count
  end    
end

