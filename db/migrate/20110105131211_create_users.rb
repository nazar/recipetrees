class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string   "login"
      t.string   "name",                       :limit => 50
      t.string   "email"
      t.string   "crypted_password",           :limit => 40
      t.string   "salt",                       :limit => 40
      t.datetime "last_seen_at"
      t.datetime "remember_token_expires_at"
      t.string   "remember_token"
      t.string   "token",                      :limit => 10
      t.boolean  "admin",                                    :default => false
      t.boolean  "activated",                                :default => false
      t.boolean  "active",                                   :default => false
      t.string   "avatar_file_name"
      t.string   "avatar_content_type",        :limit => 20
      t.integer  "avatar_file_size"
      t.datetime "avatar_updated_at"
      t.string   "profile_image_file_name"
      t.string   "profile_image_content_type", :limit => 20
      t.integer  "profile_image_file_size"
      t.datetime "profile_image_updated_at"

      t.timestamps
    end
    add_index "users", ["login"], :name => "login"
    add_index "users", ["token"], :name => "users_token_index"
  end

  def self.down
    drop_table :users
  end

end
