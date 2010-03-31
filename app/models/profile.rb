class String
  def date_or_nil
    digits = scan(/\d+/)
    Time.utc(*digits) unless digits.empty?
  end  
end
  
class Profile < ActiveRecord::Base
  has_many :assignments
  has_many :rankings, :dependent => :destroy, 
    :include => {:skill => :category},
    :order => 'skills.name'
  has_many :skills, :through => :rankings
  has_many :views
  belongs_to :user
  delegate :name, :to => :user
  
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  accepts_nested_attributes_for :rankings, :allow_destroy => true
  
  def self.find id, *more
    if id.is_a?(String) && /\D/.match(id) && (user = User.find_by_munged_name id)
      find_by_user_id user.id, *more
    end || super
  end
      
  def to_param
    user.munged_name
  end
  
  def categories
    rankings.collect {|q| q.skill.category}.uniq
  end
  
  def add_rankings_from_text text
    skill_names = skills.collect {|s| s.name}
    text.each do |row|
      if !row.empty? && row.match(/^•\s*(.+)\s*$/)
        skill_name = $1.strip
        unless skill_names.include?(skill_name)
          if skill = Skill.find(:first, :conditions => ['name LIKE ?', skill_name] )
            rankings.build :skill => skill
          else
            rankings.build.build_skill :name => skill_name
          end
        end
      end
    end
  end
    
  def add_assignments_from_text text
    return if text.empty?
    current = nil
    other_info = nil
    text.gsub('–','-').each do |row|
      case row
      when /^\s*(\d{4}(?:-\d\d)*)\s*-\s*(\d{4}(?:-\d\d)*|pågående)\s+(\S.+)/
        if current
          current.description += other_info
        end
        other_info = ''
        current = assignments.build :title => $3, :from => $1.date_or_nil, :to => $2.date_or_nil, :description => ''
      when /(.+)\s*\((\d{4}(?:-\d\d)*)\s*-\s*(\d{4}(?:-\d\d)*|pågående)\)/
        if current
          current.description += other_info
        end
        other_info = ''
        current = assignments.build :title => $1, :from => $2.date_or_nil, :to => $3.date_or_nil, :description => ''
      when /^BRANSCH\s*(.+)/: other_info += "- Bransch: " + $1
      when /^OMRÅDE\s*(.+)/: other_info += "- Område: " + $1
      when /^TEKNIK\/METOD\s*(.+)/: other_info += "- Metod: " + $1
      when /^Teknik:\s*(.+)/: other_info += "- Metod: " + $1
      when /^KUNDNYTTA\s*(.+)/: other_info += "- Kundnytta: " + $1
      when /^UPPDRAG\s*(.+)/: current.description += $1
      else current.description += row
      end
    end
    current.description += other_info
  end
end
