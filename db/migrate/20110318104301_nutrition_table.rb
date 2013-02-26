class NutritionTable < ActiveRecord::Migration

  def self.up
    add_column :nutritions, :nutrition_table, :text
  end

  def self.down
    remove_column :nutritions, :nutrition_table
  end

end
