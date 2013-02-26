class StepDescrption < ActiveRecord::Migration

  def self.up
    add_column :steps, :description, :text
  end

  def self.down
    remove_columns :steps, :description
  end

end
