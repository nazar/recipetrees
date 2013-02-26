class NutritionEachGrams < ActiveRecord::Migration

  def self.up
    add_column :nutritions, :each_grams, :float
  end

  def self.down
    remove_column :nutritions, :each_grams
  end

end
