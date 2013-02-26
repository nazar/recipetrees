class CreateRecipeByOthers < ActiveRecord::Migration

  def self.up
    create_table :recipe_by_others do |t|
      t.integer :recipe_id, :user_id
      t.text :comments

      t.timestamps
    end
    add_index :recipe_by_others, :recipe_id
    add_index :recipe_by_others, :user_id
  end

  def self.down
    drop_table :recipe_by_others
  end

end
