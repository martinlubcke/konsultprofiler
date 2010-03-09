module SearchesHelper
  def requirement_pairs
    [['Gärna', 1], ['Helst', 2], ['Viktigt', 3], ['Avgörande', 4], ['Måste', 5]]
  end
  
  def requirement_presentation value
    requirement_pairs.rassoc(value).first
  end
  
  def rankings_presentation profile, search
    rankings = profile.rankings.select {|r| search.skill_ids.include? r.skill_id}
    rankings.collect {|r| "#{r.skill.name} (#{ranking_presentation(r.value)})"}.join(', ')
  end
end
