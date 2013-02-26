class RemoveIngredientId < ActiveRecord::Migration

  def self.up
    remove_column :recipe_ingredients, :ingredient_id
  end

  def self.down
    add_column :recipe_ingredients, :ingredient_id, :integer
  end

end
