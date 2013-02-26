class CreateUserProfiles < ActiveRecord::Migration

  def self.up
    create_table :user_profiles do |t|
      t.integer  "user_id"
      t.string   "state",             :limit => 50
      t.string   "country",           :limit => 50
      t.integer  "rank"
      t.integer  "reputation",        :default => 0
      t.text     "bio"
      t.integer  "gender",                          :default => 0
      t.datetime "birth_day"
      t.string   "aim",               :limit => 20
      t.string   "yahoo",             :limit => 20
      t.string   "msn",               :limit => 20

      t.timestamps
    end
    add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"
  end

  def self.down
    drop_table :user_profiles
  end

end
