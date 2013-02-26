class CreateCategoryRecipes < ActiveRecord::Migration

  def self.up
    create_table :categories_members do |t|
      t.references :category
      t.references :member, :polymorphic => true

      t.timestamps
    end
    add_index :categories_members, :category_id
    add_index :categories_members, :member_id
  end

  def self.down
    drop_table :categories_members
  end

end
