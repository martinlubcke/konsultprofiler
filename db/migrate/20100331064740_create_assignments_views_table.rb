class CreateAssignmentsViewsTable < ActiveRecord::Migration
  def self.up
    create_table :assignments_views, :id => false do |t|
      t.references :assignment, :view
    end
  end

  def self.down
    drop_table :assignments_views
  end
end
