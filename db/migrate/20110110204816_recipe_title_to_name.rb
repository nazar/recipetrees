class RecipeTitleToName < ActiveRecord::Migration

  def self.up
    rename_column :recipes, :title, :name
  end

  def self.down
    rename_column :recipes, :name, :title
  end

end
