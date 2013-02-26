class UserCounterFollowers < ActiveRecord::Migration

  def self.up
    add_column :user_counters, :following_count, :integer, {:default => 0}
    add_column :user_counters, :followers_count, :integer, {:default => 0}
  end

  def self.down
    remove_column :user_counters, :following_count
    remove_column :user_counters, :followers_count
  end

end
