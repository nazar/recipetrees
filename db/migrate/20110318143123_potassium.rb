class Potassium < ActiveRecord::Migration

  def self.up
    add_column :nutritions, :potassium, :float
    add_column :recipes, :total_potassium, :float
  end

  def self.down
    remove_column :nutritions, :potassium
    remove_column :recipes, :total_potassium
  end

end
