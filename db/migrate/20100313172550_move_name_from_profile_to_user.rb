class MoveNameFromProfileToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :name
      t.string :first_name
      t.string :last_name
      t.remove :profile_id
    end
    change_table :profiles do |t|
      t.remove :first_name
      t.remove :last_name
      t.integer :user_id
    end
  end

  def self.down
    change_table :users do |t|
      t.string :name
      t.remove :first_name
      t.remove :last_name
      t.integer :profile_id
    end
    change_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.remove :user_id
    end
  end
end
