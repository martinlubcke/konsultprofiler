module SkillsHelper
  def group_by_category rankings
    rankings.inject({}) do |h,q|
      name = (q.respond_to?(:skill) ? q.skill : q).category.name 
      h[name] = (h[name] || []) + [q]
      h
    end.to_a.collect{|s| [s[0], s[1].sort {|a, b| a.name <=> b.name}]}.sort 
  end
end
