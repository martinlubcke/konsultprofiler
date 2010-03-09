class Assignment < ActiveRecord::Base
  belongs_to :profile
  
  def duration
    [from, to].compact.collect {|d| d.year.to_s + ((d.month > 1) ? '-' + d.month.to_s : '')}.join ' - '
  end
end
