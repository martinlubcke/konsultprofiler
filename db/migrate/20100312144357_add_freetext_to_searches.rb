class AddFreetextToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :free_text, :string
  end

  def self.down
    remove_column :searches, :free_text
  end
end
