module ProfilesHelper
  def texify text
    latex = RedCloth.new(text).to_latex
    latex = latex[0..-3] if latex.end_with?("\n\n")
    latex.gsub(/\n/, '\\\\\\\\') + "\n\n"
  end
end
