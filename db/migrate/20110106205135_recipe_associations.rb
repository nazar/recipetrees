class RecipeAssociations < ActiveRecord::Migration

  def self.up
    add_column :recipes, :cuisine_id, :integer
    add_column :recipes, :cooking_method_id, :integer
    #
    add_index :recipes, :cuisine_id
    add_index :recipes, :cooking_method_id
  end

  def self.down
    remove_column :recipes, :cuisine_id
    remove_column :recipes, :cooking_method_id
  end

end
