class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.string :name
      t.text :description
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :views
  end
end
