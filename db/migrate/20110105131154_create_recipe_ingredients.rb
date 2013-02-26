class CreateRecipeIngredients < ActiveRecord::Migration

  def self.up
    create_table :recipe_ingredients do |t|
      t.integer :recipe_id, :ingredient_id, :recipe_item_id, :measure_id
      t.string :recipe_item_type
      t.float :unit

      t.timestamps
    end
    add_index :recipe_ingredients, :recipe_id
    add_index :recipe_ingredients, :ingredient_id
    add_index :recipe_ingredients, :recipe_item_id
    add_index :recipe_ingredients, :measure_id
  end

  def self.down
    drop_table :recipe_ingredients
  end

end
