module ProfilesHelper
  def texify text
    RedCloth.new(text).to_latex
  end
end
