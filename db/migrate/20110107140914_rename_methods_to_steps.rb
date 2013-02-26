class RenameMethodsToSteps < ActiveRecord::Migration

  def self.up
    rename_table :methods, :steps
  end

  def self.down
    rename_table :steps, :methods
  end

end
