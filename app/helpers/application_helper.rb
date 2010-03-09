# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ranking_pairs
    [['Nybörjare', 1], ['Erfaren', 2], ['Mycket erfaren', 3], ['Expert', 4], ['Guru', 5]]
  end
  
  def ranking_presentation value
    ranking_pairs.rassoc(value).first
  end

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

  def swedish_date_select(f, association)
    f.date_select association, :discard_day => true,
      :use_month_names => %w{Jan Feb Mar Apr Maj Jun Jul Aug Sep Okt Nov Dec}
  end
end
