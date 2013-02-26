class CreateIngredientRelations < ActiveRecord::Migration

  def self.up
    create_table :ingredient_relations do |t|
      t.integer :ingredient_id, :relation_id
      t.timestamps
    end
    add_index :ingredient_relations, :ingredient_id
    add_index :ingredient_relations, :relation_id
  end

  def self.down
    drop_table :ingredient_relations
  end

end
