class MakeMethodsRevisable < ActiveRecord::Migration

  def self.up
    add_column :methods, :revisable_original_id, :integer
    add_column :methods, :revisable_branched_from_id, :integer
    add_column :methods, :revisable_number, :integer, :default => 0
    add_column :methods, :revisable_name, :string
    add_column :methods, :revisable_type, :string
    add_column :methods, :revisable_current_at, :datetime
    add_column :methods, :revisable_revised_at, :datetime
    add_column :methods, :revisable_deleted_at, :datetime
    add_column :methods, :revisable_is_current, :boolean, :default => 1
  end

  def self.down
    remove_column :methods, :revisable_original_id
    remove_column :methods, :revisable_branched_from_id
    remove_column :methods, :revisable_number
    remove_column :methods, :revisable_name
    remove_column :methods, :revisable_type
    remove_column :methods, :revisable_current_at
    remove_column :methods, :revisable_revised_at
    remove_column :methods, :revisable_deleted_at
    remove_column :methods, :revisable_is_current
  end

end
