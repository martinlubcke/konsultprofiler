class CreateSkillsViewsTable < ActiveRecord::Migration
  def self.up
    create_table :skills_views, :id => false do |t|
      t.references :skill, :view
    end
  end

  def self.down
    drop_table :skills_views
  end
end
