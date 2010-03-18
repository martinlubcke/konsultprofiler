class String
  def strip_dots
    %w{ÅA åa ÄA äa ÖO öo ÜU üu ÉE ée}.inject(self) {|s,r| s.gsub *r.scan(/./)}
  end
  
  def munge
    gsub(/\s+/, '_').gsub(/[^\w-]+/, '')
  end
end 

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_one :profile
  has_attached_file :photo, :styles => { :thumb => "100x100>", :small => "200x200>" },
                    :url  => "/assets/users/:id/:style/face.:extension",
                    :path => ":rails_root/public/assets/users/:id/:style/face.:extension"
  
  #validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  named_scope :without_profile, :joins => 'LEFT JOIN profiles ON profiles.user_id = users.id', :conditions => 'profiles.id IS NULL'
  
  before_validation :set_munged_name
  
  attr_protected :login, :is_admin, :password, :password_confirmation

  def to_param
    munged_name
  end
  
  def self.find id, *more
    if id.is_a?(String) && /\D/.match(id)
      User.find_by_munged_name(id, *more)
    end || super
  end
  
  def is_root_admin?
    login == 'admin'
  end  
  
  def ensure_login
    self.login ||= (first_name.strip_dots[0,3] + last_name.strip_dots[0,3]).downcase
    self.email ||= login + '@knowit.se'
    self.password ||= login
    self.password_confirmation ||= login
  end
  
  def name
    [first_name, last_name].select {|s| s && !s.empty?}.join(' ')
  end
  
  def set_munged_name
    self.munged_name = name.munge
  end
end
