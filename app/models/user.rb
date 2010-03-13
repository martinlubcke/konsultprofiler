class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :profile
  
  def is_root_admin?
    login == 'admin'
  end
end
