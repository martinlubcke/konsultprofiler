class AddMungedNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :munged_name, :string
  end

  def self.down
    remove_column :users, :munged_name
  end
end
