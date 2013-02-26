class IngredientFoodIdFt < ActiveRecord::Migration

  def self.up
    add_column :ingredients, :food_id, :integer
    add_index :ingredients, :food_id
  end

  def self.down
    remove_column :ingredients, :food_id
  end

end
