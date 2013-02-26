class IngredientGroups < ActiveRecord::Migration

  def self.up
    add_column :ingredients, :ingredient_group, :integer, {:default => 100}
  end

  def self.down
    remove_column :ingredients, :ingredient_group
  end

end
