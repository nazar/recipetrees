class RecipeRecipeCount < ActiveRecord::Migration

  def self.up
    add_column :recipes, :recipes_count, :integer, {:default => 0}
  end

  def self.down
    remove_column :recipes, :recipes_count
  end

end
