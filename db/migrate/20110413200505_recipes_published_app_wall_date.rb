class RecipesPublishedAppWallDate < ActiveRecord::Migration

  def self.up
    add_column :recipes, :facebook_app_published_at, :datetime
  end

  def self.down
    remove_column :recipes, :facebook_app_published_at
  end

end
