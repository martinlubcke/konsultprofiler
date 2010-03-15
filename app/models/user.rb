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
  
  named_scope :without_profile, :joins => 'LEFT JOIN profiles ON profiles.user_id = users.id', :conditions => 'profiles.id IS NULL'
  
  before_validation :set_munged_name

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
  
  def file_name
    munged_name.strip_dots
  end
  
  def image_path
    p = jpeg_file_path file_name
    if p.exist?
      p
    else
      jpeg_file_path 'Default'
    end    
  end
  
  def html_image_path
    '/images/' + File.basename(image_path) 
  end

  def jpeg_file_path name
    Rails.root.join 'public', 'images', name + '.jpg'
  end
  
  def set_munged_name
    self.munged_name = name.munge
  end
end
