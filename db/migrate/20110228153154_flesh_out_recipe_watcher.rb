class FleshOutRecipeWatcher < ActiveRecord::Migration

  def self.up
    add_column :recipe_watchers, :recipe_id, :integer
    add_column :recipe_watchers, :recipe_revision, :integer
    add_column :recipe_watchers, :user_id, :integer

    add_index :recipe_watchers, :recipe_id
    add_index :recipe_watchers, :user_id
  end

  def self.down
    remove_column :recipe_watchers, :recipe_id
    remove_column :recipe_watchers, :recipe_revision
    remove_column :recipe_watchers, :user_id
  end

end
