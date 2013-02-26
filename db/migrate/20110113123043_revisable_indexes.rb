class RevisableIndexes < ActiveRecord::Migration

  def self.up
    add_index :recipes, :revisable_original_id
    add_index :recipes, :revisable_branched_from_id

    add_index :recipe_ingredients, :revisable_original_id
    add_index :recipe_ingredients, :revisable_branched_from_id

    add_index :steps, :revisable_original_id
    add_index :steps, :revisable_branched_from_id
  end

  def self.down
    remove_index :recipes, :revisable_original_id
    remove_index :recipes, :revisable_branched_from_id

    remove_index :recipe_ingredients, :revisable_original_id
    remove_index :recipe_ingredients, :revisable_branched_from_id

    remove_index :steps, :revisable_original_id
    remove_index :steps, :revisable_branched_from_id
  end

end
