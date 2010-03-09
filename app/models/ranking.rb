class Ranking < ActiveRecord::Base
  belongs_to :profile
  belongs_to :skill

  validates_associated :profile, :skill
  validates_presence_of :profile, :skill

  accepts_nested_attributes_for :skill
end
