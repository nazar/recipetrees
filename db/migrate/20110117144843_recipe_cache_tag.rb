class RecipeCacheTag < ActiveRecord::Migration

  def self.up
    add_column :recipes, :cached_tag_list, :string, {:limit => 254}
  end

  def self.down
    remove_column :recipes, :cached_tag_list
  end

end
