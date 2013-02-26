class CreateCategories < ActiveRecord::Migration

  def self.up
    create_table :categories do |t|
      t.string :name, :id_path
      t.text :description
      t.integer :parent_id, :level
      t.integer :children_count, :default => 0

      t.timestamps
    end
    add_index :categories, :parent_id
    add_index :categories, :id_path
  end

  def self.down
    drop_table :categories
  end

end
