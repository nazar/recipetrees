class CategoriesFamilyId < ActiveRecord::Migration

  def self.up
    add_column :categories, :family_id, :integer
    add_index :categories, :family_id
  end

  def self.down
    remove_column :categories, :family_id
  end

end
