module ProfilesHelper
  def links_for profile
    links = []
    links.push(link_to('PDF', profile_path(profile, :format => :pdf))) 
    links.push(link_to('Redigera', edit_profile_path(profile))) if admin? || profile == current_profile
    links.push(link_to('Ta bort', profile, :confirm => 'Är du säker?', :method => :delete)) if admin?
    links.compact
  end
end
