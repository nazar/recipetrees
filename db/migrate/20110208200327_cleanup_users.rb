class CleanupUsers < ActiveRecord::Migration

  def self.up
    remove_columns(:users, :crypted_password, :salt, :remember_token_expires_at, :remember_token,
                   :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at)
    add_column :users, :bio, :string
    #
    drop_table :user_profiles
  end

  def self.down
    add_column :users, "crypted_password", :string
    add_column :users, "salt", :string
    add_column :users, "last_seen_at", :datetime
    add_column :users, "remember_token_expires_at", :datetime
    add_column :users, "remember_token", :string
    add_column :users, "avatar_file_name", :string
    add_column :users, "avatar_content_type", :string
    add_column :users, "avatar_file_size", :integer
    add_column :users, "avatar_updated_at", :datetime
    #
    remove_column :users, :bio
    #
    create_table "user_profiles", :force => true do |t|
      t.integer  "user_id"
      t.string   "state",      :limit => 50
      t.string   "country",    :limit => 50
      t.integer  "rank"
      t.integer  "reputation",               :default => 0
      t.text     "bio"
      t.integer  "gender",                   :default => 0
      t.datetime "birth_day"
      t.string   "aim",        :limit => 20
      t.string   "yahoo",      :limit => 20
      t.string   "msn",        :limit => 20
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

end
