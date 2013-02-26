class DraftRecipes < ActiveRecord::Migration

  def self.up
    add_column :recipes, :is_draft, :boolean, {:default => false}
  end

  def self.down
    remove_column :recipes, :is_draft
  end

end
