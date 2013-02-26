class RecipeWatchersCount < ActiveRecord::Migration

  def self.up
    add_column :recipes, :watchers_count, :integer, {:default => 0}
  end

  def self.down
    remove_column :recipes, :watchers_count
  end

end
