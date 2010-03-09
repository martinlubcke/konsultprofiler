class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer :skill_id
      t.integer :profile_id
      t.integer :value, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end
