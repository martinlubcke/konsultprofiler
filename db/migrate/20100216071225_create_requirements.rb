class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.integer :value, :default => 1
      t.integer :skill_id
      t.integer :search_id

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
