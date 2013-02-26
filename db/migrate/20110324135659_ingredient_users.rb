class IngredientUsers < ActiveRecord::Migration

  def self.up
    add_column :ingredients, :user_id, :integer
    add_column :ingredients, :updated_by_id, :integer

    add_index :ingredients, :user_id
    add_index :ingredients, :updated_by_id
  end

  def self.down
    remove_column :ingredients, :user_id
    remove_column :ingredients, :updated_by_id
  end

end
