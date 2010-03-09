class Add < ActiveRecord::Migration
  def self.up
    add_column :skills, :skill_category_id, :integer
  end

  def self.down
    remove_column :skills, :skill_category_id
  end
end
