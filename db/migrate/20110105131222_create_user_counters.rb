class CreateUserCounters < ActiveRecord::Migration

  def self.up
    create_table :user_counters do |t|
      t.integer  "user_id"
      t.integer  "recipes_count",        :default => 0
      t.integer  "blogs_count",        :default => 0
      t.integer  "topics_count",     :default => 0
      t.integer  "posts_count",        :default => 0
      t.integer  "friends_count",      :default => 0
      t.integer  "favourites_count",   :default => 0
      t.integer  "profile_view_count", :default => 0

      t.timestamps
    end
    add_index "user_counters", ["user_id"], :name => "index_user_counters_on_user_id"
  end

  def self.down
    drop_table :user_counters
  end

end
