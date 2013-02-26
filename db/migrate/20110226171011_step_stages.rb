class StepStages < ActiveRecord::Migration

  def self.up
    add_column :steps, :stage, :integer
  end

  def self.down
    remove_column :steps, :stage
  end

end
