class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :profile
end
