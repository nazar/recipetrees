class CreateFollowers < ActiveRecord::Migration

  def self.up
    create_table :followers do |t|
      t.integer :from_user_id, :to_user_id
      t.timestamps
    end
    add_index :followers, :from_user_id
    add_index :followers, :to_user_id
  end

  def self.down
    drop_table :followers
  end

end
