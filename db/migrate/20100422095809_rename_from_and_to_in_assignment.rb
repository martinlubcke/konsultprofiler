class RenameFromAndToInAssignment < ActiveRecord::Migration
  def self.up
    rename_column :assignments, :from, :start_at
    rename_column :assignments, :to, :end_at
  end

  def self.down
    rename_column :assignments, :end_at, :to
    rename_column :assignments, :start_at, :from
  end
end
