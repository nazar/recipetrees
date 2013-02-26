class RecipeStepsCount < ActiveRecord::Migration

  def self.up
    add_column :recipes, :steps_count, :integer, {:default => 0}
  end

  def self.down
    remove_column :recipes, :steps_count
  end

end
