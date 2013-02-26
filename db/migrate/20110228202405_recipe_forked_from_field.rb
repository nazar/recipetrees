class RecipeForkedFromField < ActiveRecord::Migration

  def self.up
    add_column :recipes, :forked_from_id, :integer
    add_index :recipes, :forked_from_id
  end

  def self.down
    remove_column :recipes, :forked_from_id
  end

end
