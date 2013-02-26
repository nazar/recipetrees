class Ratings < ActiveRecord::Migration
  def self.up
    create_table "ratings", :force => true do |t|
      t.integer  "rating",                      :default => 0
      t.datetime "created_at",                                  :null => false
      t.string   "rateable_type", :limit => 15, :default => "", :null => false
      t.integer  "rateable_id",                 :default => 0,  :null => false
      t.integer  "user_id",                     :default => 0,  :null => false
      t.string   "ip",            :limit => 15, :default => "", :null => false
    end
    add_index "ratings", ["user_id"], :name => "user_id"
    add_index "ratings", ["ip"], :name => "ip"
    add_index "ratings", ["rateable_id"], :name => "index_ratings_on_rateable_id"
  end

  def self.down
  end
end
