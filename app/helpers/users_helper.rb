module UsersHelper
  def links_for_user user
    links = []
    links.push(link_to('Visa profil', profile_path(user.profile))) if user.profile
    links.push(link_to('Redigera', edit_user_path(user))) if admin? && !user.is_admin || user == current_user || current_user.is_root_admin?
    links.push(link_to('Ta bort', user, :confirm => 'Är du säker?', :method => :delete)) if (current_user.is_root_admin? && !@user.is_root_admin?)
    links
  end
end
