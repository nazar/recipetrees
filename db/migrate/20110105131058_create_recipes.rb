class CreateRecipes < ActiveRecord::Migration

  def self.up
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.integer :created_by_id
      t.integer :difficulty, :serves_from, :serves_to
      t.integer :views_count, :topics_count, :posts_count, :favourites_count, :forks_count, :ingredients_count, :ratings_count, :default => 0
      t.float :total_time, :default => 0.0
      t.float :ratings_total, :default => 0.0

      t.timestamps
    end
    add_index :recipes, :created_by_id
  end

  def self.down
    drop_table :recipes
  end

end
