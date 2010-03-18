class Profile < ActiveRecord::Base
  has_many :assignments
  has_many :rankings, :dependent => :destroy, 
    :include => {:skill => :category},
    :order => 'skills.name'
  has_many :skills, :through => :rankings
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
  
  def add_category_from_text text
    text.each do |row|
      case row
      when /^[A-ZÅÄÖ\s\/]{4,}$/
         puts "  Header: #{row}"
      else
        s = Skill.find_by_name row.strip
        if s
          puts "  Finns:  #{row}"
        else
          puts "  Saknas: #{row}"
        end
      end
    end
  end
end
