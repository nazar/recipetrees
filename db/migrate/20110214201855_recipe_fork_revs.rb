class RecipeForkRevs < ActiveRecord::Migration

  def self.up
    add_column :recipe_forks, :at_rev, :integer
  end

  def self.down
    remove_column :recipe_forks, :at_rev
  end

end
