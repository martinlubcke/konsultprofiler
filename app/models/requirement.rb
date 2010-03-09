class Requirement < ActiveRecord::Base
  belongs_to :search
  belongs_to :skill
end

