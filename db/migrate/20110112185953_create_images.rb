class CreateImages < ActiveRecord::Migration

  def self.up
    create_table :images do |t|
      t.string   "imageable_type",       :limit => 30
      t.integer  "imageable_id"
      t.integer  "user_id"
      t.string   "picture_file_name",    :limit => 254
      t.string   "picture_content_type", :limit => 30
      t.integer  "picture_file_size"
      t.datetime "picture_updated_at"
      t.integer  "views_count",                         :default => 0

      t.timestamps
    end
    add_index :images, :imageable_id
    add_index :images, :user_id
  end

  def self.down
    drop_table :images
  end

end
