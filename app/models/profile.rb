class Profile < ActiveRecord::Base
  has_many :assignments
  has_many :rankings, :dependent => :destroy, 
    :include => {:skill => :category},
    :order => 'skills.name'
  has_many :skills, :through => :rankings
  
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  accepts_nested_attributes_for :rankings, :allow_destroy => true
  
  def name
    first_name + " " + last_name
  end
  
  def categories
    rankings.collect {|q| q.skill.category}.uniq
  end
  
  def rankings_by_category
    rankings.inject({}) do |h,q|
      name = q.skill.category.name 
      h[name] = (h[name] || []) + [q]
      h
    end.to_a.sort 
  end
  
  def html_image_path
    '/images/' + File.basename(image_path) 
  end

  def image_path
    p = jpeg_file_path name
    if p.exist?
      p
    else
      jpeg_file_path 'Default'
    end
  end
  
  def jpeg_file_path name
    Rails.root.join 'public', 'images', jpeg_file_name(name)
  end
  
  def jpeg_file_name name
    escape(name) +'.jpg'
  end
  
  def escape word
    word.gsub('ü', 'u').gsub(/\s+/, '_')
  end
  
  def to_xml
    super(:include => [:assignments, :skills])
  end
end
