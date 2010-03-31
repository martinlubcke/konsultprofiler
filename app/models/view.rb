class View < ActiveRecord::Base
  belongs_to :profile
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :assignments
end
