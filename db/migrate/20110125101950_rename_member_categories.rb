class RenameMemberCategories < ActiveRecord::Migration

  def self.up
    rename_table :members_categories, :categories_members
  end

  def self.down
    rename_table :categories_members, :members_categories
  end

end
