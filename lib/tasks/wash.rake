desc "Tries to wash dirty skill input splitting a skill 'HTML/CSS' into 'HTML' and 'CSS'"
task :wash => :environment do
  def ask question
    puts question + ' (j/N)'
    return /^[jJ]/.match STDIN.gets
  end
  
  Skill.all.select {|s| !/[a-zåäöA-ZÅÄÖ]/.match s.name}. each do |skill|
    if ask("Ta bort '#{skill.name}'?")
      skill.destroy
    end
  end
  Skill.all.select {|s| /och|\/|,/.match s.name}.each do |skill|
    target_names = skill.name.split(/\s*(?:och|\/|,)\s*/)
    %w{Java JBoss Oracle}.each do |s|
      re = Regexp.new '^' + s
      if re.match(target_names.first)
        target_names.collect! do |t|
          re.match(t) ? t : "#{s} #{t}" 
        end
        target_names.push(s) unless target_names.include?(s)
      end
    end
    targets_presentation = target_names.collect{|a| "'#{a}'"}.join(' och ')
    if ask("Dela upp '#{skill.name}' i #{targets_presentation}?")
      targets = target_names.collect {|name| Skill.find_by_name(name) ||
        Skill.create(:name => name, :category => skill.category)}
      skill.rankings.each do |ranking|
        targets.each do |target|
          target.rankings.create :value => ranking.value, :profile => ranking.profile
        end
      end
      skill.destroy
    end
  end
end
