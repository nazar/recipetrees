class StepToStepNo < ActiveRecord::Migration

  def self.up
    rename_column :steps, :step, :step_no
  end

  def self.down
    rename_column :steps, :step_no, :step
  end

end
