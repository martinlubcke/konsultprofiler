class SkillCategory < ActiveRecord::Base
  has_many :skills, :order => 'name'
end
