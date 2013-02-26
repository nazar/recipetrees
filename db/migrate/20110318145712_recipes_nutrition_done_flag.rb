class RecipesNutritionDoneFlag < ActiveRecord::Migration

  def self.up
    add_column :recipes, :done_nutrition_at, :datetime
  end

  def self.down
    remove_column :recipes, :done_nutrition_at
  end

end
