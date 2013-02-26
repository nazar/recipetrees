class MakeRecipesRevisable < ActiveRecord::Migration

  def self.up
    add_column :recipes, :revisable_original_id, :integer
    add_column :recipes, :revisable_branched_from_id, :integer
    add_column :recipes, :revisable_number, :integer, :default => 0
    add_column :recipes, :revisable_name, :string
    add_column :recipes, :revisable_type, :string
    add_column :recipes, :revisable_current_at, :datetime
    add_column :recipes, :revisable_revised_at, :datetime
    add_column :recipes, :revisable_deleted_at, :datetime
    add_column :recipes, :revisable_is_current, :boolean, :default => 1
  end

  def self.down
    remove_column :recipes, :revisable_original_id
    remove_column :recipes, :revisable_branched_from_id
    remove_column :recipes, :revisable_number
    remove_column :recipes, :revisable_name
    remove_column :recipes, :revisable_type
    remove_column :recipes, :revisable_current_at
    remove_column :recipes, :revisable_revised_at
    remove_column :recipes, :revisable_deleted_at
    remove_column :recipes, :revisable_is_current
  end
end
