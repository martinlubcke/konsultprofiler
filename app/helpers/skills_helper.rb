module SkillsHelper
  def group_by_category rankings
    rankings.inject({}) do |h,q|
      name = ensure_skill(q).category.name 
      h[name] = (h[name] || []) + [q]
      h
    end.to_a.collect{|s| [s[0], s[1].sort {|a, b| ensure_skill(a).name <=> ensure_skill(b).name}]}.sort 
  end
  
  def ensure_skill skill
    skill.respond_to?(:skill) ? skill.skill : skill
  end
end
