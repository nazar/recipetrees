class RecipeTotalTimeToInteger < ActiveRecord::Migration

  def self.up
    change_column :recipes, :total_time, :integer
  end

  def self.down
    change_column :recipes, :total_time, :float
  end

end
