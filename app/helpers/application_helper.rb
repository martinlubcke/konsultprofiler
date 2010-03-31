# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ranking_pairs
    [['Nybörjare', 1], ['Erfaren', 2], ['Mycket erfaren', 3], ['Expert', 4], ['Guru', 5]]
  end
  
  def ranking_presentation value
    ranking_pairs.rassoc(value).first
  end

  # These two functions are taken from railscasts. They are explained here:
  # http://media.railscasts.com/videos/197_nested_model_form_part_2.mov
  # Note that most of tje Ajax logic i in the file 'application.js'
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def chained_skill_selects_for model, relation
    select_tag(:category_id, 
      	options_for_select(["Välj kategori"] + SkillCategory.all(:order => 'name').collect {|c| [c.name, c.id]}),
      	:onchange => remote_function(:update => "new_#{relation}_skills", 
      	                             :url => skill_selector_path, 
      	                             :with => 'Form.Element.serialize(this)')) +
    select_tag("new_#{relation}_skills", options_for_select(["Välj kategori först"]), 
		    :name => "#{model}[#{relation}_attributes][new_#{relation}][skill_id]")
  end

  def swedish_date_select(f, association)
    f.date_select association, :discard_day => true,
      :use_month_names => %w{Jan Feb Mar Apr Maj Jun Jul Aug Sep Okt Nov Dec}
  end
  
  def link_divs
    if current_user
      link_div('Inloggad som', [
          [current_user.name, user_path(current_user)],
          ['Min profil', current_profile && profile_path(current_profile), current_profile],
          ['Logga ut', logout_path]
        ]) +
      link_div('Användare', [
          ['Alla', users_path],
          ['Ny', new_user_path]
        ], admin?) +
      link_div('Profiler', [
            ['Alla', profiles_path],
            ['Ny', new_profile_path, admin?]
          ]) +
      link_div('Sökningar', [
          ['Tidigare', searches_path],
          ['Ny', new_search_path]
        ]) +
      link_div('Kompetenser', [
          ['Alla', skills_path],
          ['Ny', new_skill_path]
        ], admin?) +
      link_div('Övrigt', [['Hitta kollega', find_user_path]]) +
      if defined?(@profile) && !@profile.new_record?
        link_div(@profile.name, [
                ['PDF', pdf_path(@profile)],               
                ['Redigera', edit_profile_path(@profile), admin? || @profile == current_profile],
                ['Från worddokument', edit_from_document_path(@profile), admin? || @profile == current_profile],
                ['Vyer', profile_views_path(@profile), admin?],
                ['Ny vy', new_profile_view_path(@profile), admin?],
                ['Ta bort', profile_path(@profile, :confirm => 'Är du säker?', :method => :delete), admin?]
              ]) +
          '<div style="margin-left:8px;">' + mail_to('', 'Mejla', 
                    :subject => 'Konsulten jag vill tipsa om', 
                    :body => body_for(@profile)) + "</div>\n"
      else
        ''
      end +
      if defined?(@user) && !@user.new_record?
        link_div(@user.name, [
          ['Redigera', edit_user_path(@user), admin? && !@user.is_admin || @user == current_user],               
          ['Visa profil', @user.profile && profile_path(@user.profile), @user.profile],               
          ['Redigera profil', @user.profile && edit_profile_path(@user.profile), @user.profile && (admin? || @user == current_user)],               
          ['Ta bort', user_path(@user, :confirm => 'Är du säker?', :method => :delete), admin? && !@user.is_admin]
        ])
      else
        ''
      end
    else
      link_div('Logga in', login_path)
    end
  end
  
  def link_div title, content, condition=true
    return '' unless  condition
    if content.is_a?(String)
      "<div>#{link_to_unless_current title, content}</div>"
    else
      content = content.select {|c| c[2] != false}
      if content.empty?
        ''
      else
        "<div><b>#{title}</b>\n<div style=\"margin-left:8px;\">#{content.collect {|l| link_div *l}.join("\n")}</div></div>"
      end
    end
  end
  
  def body_for profile
    "Hej,\rKonsulten jag rekommenderar heter #{profile.name}.\rHär kan du läsa mer om konsulten:\r#{profile_url(profile, :format => :pdf)}\r\rmvh\r#{current_user.name}"
  end
end
