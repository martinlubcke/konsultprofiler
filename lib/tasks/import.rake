desc "Imports all xml files in Import Folder"
task :import => :environment do
  require 'rexml/document'
  include REXML
  
  def skill name, type, skills, categories
    skills[name] = skills[name] || Skill.find(:first, :conditions => ['name LIKE ?', /^\s*(.*[^\s,]),?\s*$/.match(name)[1]])
    unless skills[name]
      categories[type] = categories[type] || SkillCategory.find_by_name(type) || SkillCategory.new(:name => type)
      skills[name] = Skill.new(:name => name, :category => categories[type])
    end
    skills[name]
  end

  class Element
    def get_children type
      each_element "Data" do |child|
        if type.match child.attributes['Type']
          yield child
        end
      end
    end

    def get_content type
      get_children type do |child|
        content = (c = child.elements['Content']) ? c.text : nil
        infos = (1..10).collect {|i| child.attributes["Info#{i}"]}.compact
        if block_given?
          yield child, child.attributes['Type'], content, infos
        else
          return content
        end
      end
    end
  end

  def date_or_nil date
    date.empty? ? nil : Time.utc(*date.scan(/\d+/))
  end
  
  Dir.glob(Rails.root.join 'import', '*.xml') do |file_name|
    begin
      puts "Reading file #{File.basename  file_name}..."
      p = Profile.new
      skills = {}
      categories = {}
      root = Document.new(File.new(file_name)).root
      old = /Old/.match root.attributes['Template']
      root.get_content /Sammanfattning/ do |element, name, content, infos|
        p.build_user :first_name => infos[0], :last_name => infos[1]
        p.description = content
      end
      if old
        root.get_content /Namn/ do |element, name, content, infos|
          name = *content.split(' ')
          p.build_user :first_name => name[0], :last_name => name[1]
        end
      end
      p.birth = root.get_content(/Födelseår/).to_i
      re = /^Kompetens\:\s*(.+)/
      root.get_content re do |element, name, content, infos|
        category_name = re.match(name)[1]
        p.skills += content.split("\n").collect {|skill_name| skill(skill_name, category_name, skills, categories)}
      end
      root.get_content /Uppdrag/ do |element, name, content, infos|
        if old
          title, start, stop = infos
        else
          start, stop, title = infos
        end
        start = date_or_nil start
        stop = date_or_nil stop
        desc = content || element.get_content(/Uppdrag/)
        p.assignments.push(Assignment.new :profile => p, :title => title, :from => start, :to => stop, :description => desc)
      end
      p.user.ensure_login
      unless p.save
        puts p.errors.full_messages
      else
        puts "   ...Done"
      end
    #rescue
    #  puts "   ...could not read #{File.basename file_name}"
    end
  end
end
