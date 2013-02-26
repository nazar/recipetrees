class IngredientPostsTopicsCount < ActiveRecord::Migration

  def self.up
    add_column :ingredients, :posts_count, :integer, {:default => 0}
    add_column :ingredients, :topics_count, :integer, {:default => 0}
    add_column :ingredients, :views_count, :integer, {:default => 0}
    add_column :ingredients, :images_count, :integer, {:default => 0}
  end

  def self.down
    remove_column :ingredients, :posts_count
    remove_column :ingredients, :topics_count
    remove_column :ingredients, :views_count
    remove_column :ingredients, :images_count
  end

end
