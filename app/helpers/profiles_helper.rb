module ProfilesHelper
  def links_for profile
    links = []
    links.push(link_to('PDF', pdf_path(profile))) 
    links.push(mail_to('', 'Skicka profil', 
        :subject => 'Konsulten jag vill tipsa om', 
        :body => body_for(profile)))
    links.push(link_to('Redigera', edit_profile_path(profile))) if admin? || profile == current_profile
    links.push(link_to('Redigera från worddokument', edit_from_document_path(profile))) if admin? || profile == current_profile
    links.push(link_to('Ta bort', profile, :confirm => 'Är du säker?', :method => :delete)) if admin?
    links.compact
  end
  
  def body_for profile
    "Hej,\rKonsulten jag rekommenderar heter #{profile.name}.\rHär kan du läsa mer om konsulten:\r#{profile_url(profile, :format => :pdf)}\r\rmvh\r#{current_user.name}"
  end
end
