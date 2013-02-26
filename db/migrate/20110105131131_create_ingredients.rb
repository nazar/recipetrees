class CreateIngredients < ActiveRecord::Migration

  def self.up
    create_table :ingredients do |t|
      t.string :name
      t.text :description
      t.integer :recipes_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end

end
