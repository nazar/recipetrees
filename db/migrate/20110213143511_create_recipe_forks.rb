class CreateRecipeForks < ActiveRecord::Migration

  def self.up
    create_table :recipe_forks do |t|
      t.integer :from_recipe_id, :to_recipe_id, :forked_by_id
      t.timestamps
    end
    add_index :recipe_forks, :from_recipe_id
    add_index :recipe_forks, :to_recipe_id
    add_index :recipe_forks, :forked_by_id
  end

  def self.down
    drop_table :recipe_forks
  end

end
