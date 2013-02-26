class AddIngredientNameIndex < ActiveRecord::Migration

  def self.up
    add_index :ingredients, :name
  end

  def self.down
    remove_index :ingredients, :name
  end

end
