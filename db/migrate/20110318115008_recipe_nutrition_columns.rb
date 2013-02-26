class RecipeNutritionColumns < ActiveRecord::Migration

  def self.up
    add_column :recipes, :total_fiber, :float
    add_column :recipes, :total_protein, :float
    add_column :recipes, :total_fat, :float
    add_column :recipes, :total_sugar, :float
    add_column :recipes, :total_sodium, :float
    add_column :recipes, :total_calories, :float
    add_column :recipes, :total_carbohydrate, :float
    add_column :recipes, :total_saturated_fat, :float
    add_column :recipes, :total_cholesterol, :float
  end

  def self.down
    remove_column :recipes, :total_fiber
    remove_column :recipes, :total_protein
    remove_column :recipes, :total_fat
    remove_column :recipes, :total_sugar
    remove_column :recipes, :total_sodium
    remove_column :recipes, :total_calories
    remove_column :recipes, :total_carbohydrate
    remove_column :recipes, :total_saturated_fat
    remove_column :recipes, :total_cholesterol
  end

end
