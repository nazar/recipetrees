class CatoriesMembersRename < ActiveRecord::Migration

  def self.up
    rename_table :categories_members, :members_categories
  end

  def self.down
    rename_table :members_categories, :categories_members
  end

end
