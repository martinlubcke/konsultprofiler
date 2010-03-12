class AddLoginAndPasswordToProfile < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.string :login
      t.string :encrypted_password
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :login
      t.remove :encrypted_password
    end
  end
end
